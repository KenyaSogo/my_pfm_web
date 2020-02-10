require 'open-uri'
require 'nokogiri'
require 'csv'

class ScrapeMyPfmJob < ApplicationJob
  class ScrapingError < StandardError; end

  queue_as :default

  def perform(user_id, asset_id)
    user = User.find(user_id)
    asset = Asset.find(asset_id)
    return if user.blank? || user&.pfm_account_id.blank? || user&.pfm_account_password.blank? || asset.blank? || asset.user_id != user.id

    agent = Mechanize.new
    agent.user_agent = 'Windows Chrome'

    url = 'https://moneyforward.com/cf'
    cf_strings = nil
    agent.get(url) do |page|
      cf_page = page.form_with(id: 'new_sign_in_session_service') do |form|
        form.field_with(id: 'sign_in_session_service_email').value = user.pfm_account_id
        form.field_with(id: 'sign_in_session_service_password').value = user.pfm_account_password
      end.submit

      cf_csv_file = cf_page.links.find { |l| l.text == 'CSVファイル' }&.click
      cf_strings = cf_csv_file&.body&.toutf8&.split("\n")&.map { |r| CSV.parse(r).flatten }
    end

    return if cf_strings.blank?
    fail ScrapingError, 'invalid size row' unless cf_strings.all? { |r| r.size == 10 }
    fail ScrapingError, 'invalid header' unless cf_strings.first.include?('計算対象')

    cf_hashes = convert_cf_strings_to_hashes(cf_strings)

    ActiveRecord::Base.transaction do
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
    end
  end

  private

  def convert_cf_strings_to_hashes(cf_strings)
    cf_header_string = cf_strings.first
    cf_column_index = {
      is_calculattion_target: cf_header_string.index('計算対象'),
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
    required_column_names = [
      :is_calculattion_target,
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
end
