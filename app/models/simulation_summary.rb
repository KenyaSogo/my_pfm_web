class SimulationSummary < ApplicationRecord
  belongs_to :simulation
  belongs_to :main_breakdown_type, class_name: 'SimulationBreakdownType'
  belongs_to :main_section_type, class_name: 'SimulationSectionType'
  has_one :simulation_summary_by_account, dependent: :destroy
  has_one :summary_by_asset_type, dependent: :destroy
  has_many :sum_by_account_classes, dependent: :destroy

  validate :validate_unity_within_simulation, on: :create
  validates :main_breakdown_type_id, :main_breakdown_id, :main_section_type_id, :main_section_id, :search_from, :search_to,
              presence: { message: 'main_breakdown, main_section, search_from, search_to must be all filled or all blank' }, on: :update, if: :main_view_setting?
  validates :main_breakdown_type_id, inclusion: { in: :existing_breakdown_type_ids }, allow_nil: true
  validates :main_breakdown_id, inclusion: { in: :related_breakdown_ids }, allow_nil: true
  validates :main_section_type_id, inclusion: { in: :breakdown_related_section_type_ids }, allow_nil: true
  validates :main_section_id, inclusion: { in: :related_section_ids }, allow_nil: true
  validates :search_from, inclusion: { in: -12..0 }, allow_nil: true
  validates :search_to, inclusion: { in: 1..12 }, allow_nil: true

  def current_balance
    return 0 if main_breakdown_id.blank? || main_section_id.blank?

    case main_breakdown_type_id
    when 1 # by_account
      current_balance = simulation_summary_by_account.sum_account_dailies
                          .where(asset_account_id: main_section_id)
                          .where(base_date: Date.today)
                          .pluck(:balance).first
    when 2 # by_asset_type
      current_balance = summary_by_asset_type.sum_asset_type_dailies
                          .where(asset_type_id: main_section_id)
                          .where(base_date: Date.today)
                          .pluck(:balance).first
    when 3 # by_account_class
      current_balance = sum_by_account_classes.find(main_breakdown_id).sum_acct_class_dailies
                          .where(simulation_acct_class_id: main_section_id)
                          .where(base_date: Date.today)
                          .pluck(:balance).first
    end

    current_balance.presence || 0
  end

  def average_balance
    return 0 if main_breakdown_id.blank? || main_section_id.blank?

    case main_breakdown_type_id
    when 1 # by_account
      average_balance = simulation_summary_by_account.sum_account_dailies
                          .where(asset_account_id: main_section_id)
                          .where('base_date >= ?', Date.today.since(search_from.month)).where('base_date <= ?', Date.today.since(search_to.month))
                          .average(:balance).round
    when 2 # by_asset_type
      average_balance = summary_by_asset_type.sum_asset_type_dailies
                          .where(asset_type_id: main_section_id)
                          .where('base_date >= ?', Date.today.since(search_from.month)).where('base_date <= ?', Date.today.since(search_to.month))
                          .average(:balance).round
    when 3 # by_account_class
      average_balance = sum_by_account_classes.find(main_breakdown_id).sum_acct_class_dailies
                          .where(simulation_acct_class_id: main_section_id)
                          .where('base_date >= ?', Date.today.since(search_from.month)).where('base_date <= ?', Date.today.since(search_to.month))
                          .average(:balance).round
    end

    average_balance.presence || 0
  end

  private

  def related_section_ids
    case main_section_type_id
    when 1 # asset_account
      simulation_summary_by_account.sum_account_dailies.pluck(:asset_account_id).uniq
    when 2 # asset_type
      summary_by_asset_type.sum_asset_type_dailies.pluck(:asset_type_id).uniq
    when 3 # asset_account_class
      SumByAccountClass.where(id: main_breakdown_id).joins(:sum_acct_class_dailies)
        .select(sum_acct_class_dailies: :simulation_acct_class_id).distinct.pluck(:simulation_acct_class_id).compact
    end
  end

  def breakdown_related_section_type_ids
    case main_breakdown_type_id
    when 1 # by_account
      [1] # asset_account
    when 2 # by_asset_type
      [2] # asset_type
    when 3 # by_account_class
      [3] # asset_account_class
    end
  end

  def related_breakdown_ids
    case main_breakdown_type_id
    when 1 # by_account
      [simulation_summary_by_account.id]
    when 2 # by_asset_type
      [summary_by_asset_type.id]
    when 3 # by_account_class
      sum_by_account_classes.pluck(:id)
    end
  end

  def existing_breakdown_type_ids
    existing_type_ids = [1, 2]
    existing_type_ids << 3 if sum_by_account_classes.present?

    existing_type_ids
  end

  def main_view_setting?
    main_breakdown_type_id.present? || main_breakdown_id.present? || main_section_type_id.present? || main_section_id.present? ||
      search_from.present? || search_to.present?
  end

  def validate_unity_within_simulation
    return if SimulationSummary.where(simulation_id: simulation.id).size == 0
    errors.add(:base, 'simulation_summary must be single')
  end
end
