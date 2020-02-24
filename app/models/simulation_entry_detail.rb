class SimulationEntryDetail < ApplicationRecord
  belongs_to :simulation_entry
  belongs_to :asset_account
  belongs_to :item
  belongs_to :sub_item
  has_many :simulation_result_activities, dependent: :destroy

  validates :asset_account_id, inclusion: { in: :related_asset_account_ids }
  # date validation (presence, absence, inclusion, valid_date)
  validates :transaction_date_year, :transaction_date_month, :transaction_date_day, presence: true, if: :entry_type_any_time?
  validates :transaction_date_weekday, absence: true, if: :entry_type_any_time?
  validate :validate_transaction_year_month_day, if: :entry_type_any_time?
  validates :transaction_date_year, inclusion: { in: 1900..2400, if: :entry_type_any_time? }
  validates :transaction_date_year, :transaction_date_month, :transaction_date_weekday, :transaction_date_day, absence: true, if: :entry_type_daily?
  validates :transaction_date_weekday, presence: true, if: :entry_type_weekly?
  validates :transaction_date_year, :transaction_date_month, :transaction_date_day, absence: true, if: :entry_type_weekly?
  validates :transaction_date_weekday, inclusion: { in: 1..7, if: :entry_type_weekly? }
  validates :transaction_date_day, presence: true, if: :entry_type_monthly?
  validates :transaction_date_year, :transaction_date_month, :transaction_date_weekday, absence: true, if: :entry_type_monthly?
  validates :transaction_date_day, inclusion: { in: 1..31, if: :entry_type_monthly? }
  validates :transaction_date_month, :transaction_date_day, presence: true, if: :entry_type_yearly?
  validates :transaction_date_year, :transaction_date_weekday, absence: true, if: :entry_type_yearly?
  validate :validate_transaction_month_day, if: :entry_type_yearly?
  # date validation end
  validates :description, length: { maximum: 100 }
  validates :amount, :item_id, :sub_item_id, presence: true
  validates :amount, numericality: { only_integer: true }
  validates :item_id, inclusion: { in: :related_item_ids }
  validates :sub_item_id, inclusion: { in: :related_sub_item_ids, message: 'is not related with item' }

  private

  def related_asset_account_ids
    simulation_entry.simulation.asset.asset_accounts.map(&:id)
  end

  def related_item_ids
    simulation_entry.simulation.asset.items.map(&:id)
  end

  def related_sub_item_ids
    item.sub_items.map(&:id)
  end

  def validate_transaction_year_month_day
    return if transaction_date_year.blank? || transaction_date_month.blank? || transaction_date_day.blank?
    unless Date.valid_date?(transaction_date_year, transaction_date_month, transaction_date_day)
      [:transaction_date_year, :transaction_date_month, :transaction_date_day].each { |attr| errors.add(attr, 'is invalid date') }
    end
  end

  def validate_transaction_month_day
    return if transaction_date_month.blank? || transaction_date_day.blank?
    unless Date.valid_date?(2000, transaction_date_month, transaction_date_day)
      [:transaction_date_month, :transaction_date_day].each { |attr| errors.add(attr, 'is invalid date') }
    end
  end

  def entry_type_any_time?
    simulation_entry.simulation_entry_type_id == 1
  end

  def entry_type_daily?
    simulation_entry.simulation_entry_type_id == 2
  end

  def entry_type_weekly?
    simulation_entry.simulation_entry_type_id == 3
  end

  def entry_type_monthly?
    simulation_entry.simulation_entry_type_id == 4
  end

  def entry_type_yearly?
    simulation_entry.simulation_entry_type_id == 5
  end
end
