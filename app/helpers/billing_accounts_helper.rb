module BillingAccountsHelper
  def credit_account_options(simulation)
    # asset_type: credit_card
    account_options(simulation, [3])
  end

  def withdrawal_month_offset_options
    {
      'this_month': 0,
      'next_month': 1,
    }.merge((2..12).map { |i| ["#{i}_months_after", i] }.to_h)
  end

  def withdrawal_month_offset_value(offset)
    withdrawal_month_offset_options.key(offset)
  end

  def billing_item_options(simulation)
    simulation.asset.items.map { |i| [i.name, i.id] }
  end

  def billing_sub_item_options(simulation)
    item_ids = simulation.asset.items.map(&:id)
    SubItem.where(item_id: item_ids).includes(:item).map { |s| ["#{s.name} (#{s.item.name})", s.id] }
  end

  def debit_account_options(simulation)
    # asset_type: bank
    account_options(simulation, [2])
  end

  def debit_item_options(simulation)
    billing_item_options(simulation)
  end

  def debit_sub_item_options(simulation)
    billing_sub_item_options(simulation)
  end

  private

  def account_options(simulation, asset_type_ids)
    simulation.asset.asset_accounts.select { |a| a.asset_type_id.in?(asset_type_ids) }.map { |a| [a.name, a.id] }
  end
end
