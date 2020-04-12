require 'csv'

class ScrapeMyPfmJob < ApplicationJob
  include ActiveJob::Status

  class ScrapingError < StandardError; end

  queue_as :default

  def perform(user_id, asset_id)
    user = User.find(user_id)
    asset = Asset.find(asset_id)
    return if user.blank? || user&.pfm_account_id.blank? || user&.pfm_account_password.blank? || asset.blank? || asset.user_id != user.id

    asset.update!(last_aggregate_started_at: DateTime.now)

    cf_strings_array = [-1, 0, 1].each_with_object([]) do |month_offset, a|
      a << scrape_pfm_cf_data!(user, month_offset)
    end
    cf_strings_array.each { |cf_strings| parse_and_save_cf_strings!(asset, cf_strings) }

    asset.update!(last_aggregate_succeeded_at: DateTime.now)
  end

  private

  def scrape_pfm_cf_data!(user, month_offset)
    content = execute_phantom_js_scraping_script('https://moneyforward.com/cf', phantom_js_scraping_script(user, month_offset))
    fail ScrapingError, 'content cant detected' if content.blank?

    csv_string = content.match(/.*<body id="page-transaction">(.*)<div id="footer-me">.*/m)&.captures&.first
    fail ScrapingError, 'csv_string cant detected' if csv_string.blank?

    cf_strings = csv_string.split("\n").map { |r| CSV.parse(r).flatten }

    cf_strings
  end

  def phantom_js_scraping_script(user, month_offset)
    <<-SCRIPT
      let pfmId = '#{user.pfm_account_id}';
      let pfmPass = '#{user.pfm_account_password}';

      await page.waitForSelector('a._2YH0UDm8.ssoLink');
      page.click('a._2YH0UDm8.ssoLink');

      await page.waitForSelector('input._2mGdHllU.inputItem');
      await page.type('input._2mGdHllU.inputItem', pfmId, {delay:100});
      page.click('input.zNNfb322.submitBtn.homeDomain');

      await page.waitForSelector('input._1vBc2gjI.inputItem');
      await page.type('input._1vBc2gjI.inputItem', pfmPass, {delay:100});
      page.click('input.zNNfb322.submitBtn.homeDomain');

      await page.waitForSelector('#page-transaction');
      await page.evaluate(
        () => {
          var xhr = new XMLHttpRequest();
          xhr.open('GET', '#{csv_request_url(month_offset)}');
          xhr.overrideMimeType('text/plain; charset=Shift_JIS');
          xhr.send();
          xhr.onload = function(e) {
            $('#page-transaction').text(xhr.responseText);
          };
        }
      );

      page.done();
    SCRIPT
  end

  def csv_request_url(month_offset)
    from_date = Date.new(today.year, today.month, 25).last_month.since(month_offset.month)
    'https://moneyforward.com/cf/csv?' + [
      "from=#{[from_date.year, from_date.strftime('%m'), from_date.strftime('%d')].join('%2F')}",
      "month=#{from_date.month}",
      "year=#{from_date.year}",
    ].join('&')
  end

  def today
    @today ||= Date.today
  end

  def execute_phantom_js_scraping_script(target_url, script)
    uri = URI.parse('https://PhantomJsCloud.com/api/browser/v2/ak-6e6c5-01g1v-23fbz-3nmhm-bb2cf/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    phantom_js_request = Net::HTTP::Post.new(uri.request_uri)

    post_data = {
      url: target_url,
      renderType: 'automation',
      outputAsJson: true,
      overseerScript: script
    }.to_json
    phantom_js_request.body = post_data

    phantom_js_response_raw = http.request(phantom_js_request)

    phantom_js_response = JSON.parse(phantom_js_response_raw.body.toutf8, symbolize_names: true)
    content = phantom_js_response[:pageResponses]&.first&.dig(:frameData, :content)

    content
  end

  def parse_and_save_cf_strings!(asset, cf_strings)
    return if cf_strings.blank?
    fail ScrapingError, 'invalid size row' unless cf_strings.all? { |r| r.size == 10 }
    cf_strings.first.each { |header| header.replace('計算対象') if header == '荐対象' }
    fail ScrapingError, "invalid csv header: #{cf_strings.first}" unless cf_strings.first.include?('計算対象')

    cf_hashes = convert_cf_strings_to_hashes!(cf_strings)

    ApplicationRecord.transaction do
      cf_hashes.map { |r| r[:asset_account_name] }.uniq.each do |asset_account_name|
        AssetAccount.find_or_create_by!(asset_id: asset.id, name: asset_account_name)
      end
      cf_hashes.map { |r| r[:item_name] }.uniq.each do |item_name|
        Item.find_or_create_by!(asset_id: asset.id, name: item_name)
      end
      cf_hashes.map { |r| { item_name: r[:item_name], sub_item_name: r[:sub_item_name] } }.uniq.each do |item_and_sub_item_name|
        parent_item = Item.find_by(asset_id: asset.id, name: item_and_sub_item_name[:item_name])
        SubItem.find_or_create_by!(item_id: parent_item.id, name: item_and_sub_item_name[:sub_item_name])
      end

      cf_hashes.each do |cf_hash|
        asset_account = AssetAccount.find_by(asset_id: asset.id, name: cf_hash[:asset_account_name])
        exist_asset_activity = AssetActivity.find_by(asset_account_id: asset_account.id, unique_key: cf_hash[:unique_key])
        if exist_asset_activity.present?
          exist_asset_activity.attributes = asset_activity_attributes(asset_account, cf_hash)
          exist_asset_activity.save! if exist_asset_activity.changed?
        else
          AssetActivity.create!(asset_activity_attributes(asset_account, cf_hash))
        end
      end
    end
  end

  def convert_cf_strings_to_hashes!(cf_strings)
    cf_header_string = cf_strings.first
    cf_column_index = {
      is_calculation_target: cf_header_string.index('計算対象'),
      transaction_date: cf_header_string.index('日付'),
      description: cf_header_string.index('内容'),
      amount: cf_header_string.index('金額（円）'),
      asset_account_name: cf_header_string.index('保有金融機関'),
      item_name: cf_header_string.index('大項目'),
      sub_item_name: cf_header_string.index('中項目'),
      memo: cf_header_string.index('メモ'),
      is_transfer: cf_header_string.index('振替'),
      unique_key: cf_header_string.index('ID'),
    }
    fail ScrapingError, "invalid csv header: #{cf_header_string}" if cf_column_index.values.include?(nil)
    required_column_names = [
      :is_calculation_target,
      :transaction_date,
      :amount,
      :asset_account_name,
      :item_name,
      :sub_item_name,
      :is_transfer,
      :unique_key,
    ]
    cf_data_strings = cf_strings - [cf_header_string]
    cf_hashes = cf_data_strings.each_with_object([]) do |cf_string_row, a|
      a << cf_column_index.each_with_object({}) do |(column_name, index), h|
        value = cf_string_row[index]
        fail ScrapingError, 'unexpected blank data' if value.blank? && column_name.in?(required_column_names)
        h[column_name] = value
      end
    end

    cf_hashes
  end

  def asset_activity_attributes(asset_account, cf_hash)
    item = Item.find_by(asset_id: asset_account.asset.id, name: cf_hash[:item_name])
    sub_item = SubItem.find_by(item_id: item.id, name: cf_hash[:sub_item_name])
    {
      asset_account_id: asset_account.id,
      transaction_date: cf_hash[:transaction_date],
      description: cf_hash[:description],
      amount: cf_hash[:amount],
      item_id: item.id,
      sub_item_id: sub_item.id,
      is_transfer: cf_hash[:is_transfer],
      is_calculation_target: cf_hash[:is_calculation_target],
      unique_key: cf_hash[:unique_key],
    }
  end
end
