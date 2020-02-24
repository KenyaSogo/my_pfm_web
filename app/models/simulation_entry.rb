class SimulationEntry < ApplicationRecord
  belongs_to :simulation
  belongs_to :simulation_entry_type
  has_many :simulation_entry_details, dependent: :destroy

  validates :name, :simulation_entry_type_id, presence: true
  validates :apply_from, :apply_to, presence: true, unless: :entry_type_any_time?
  validates :apply_from, :apply_to, absence: { message: 'must be blank when entry type is any_time', if: :entry_type_any_time? }
  validates :name, uniqueness: { scope: :simulation }
  validate :validate_apply_from_to_range
  validate :validate_entry_type_change, on: :update

  def entry_type_any_time?
    simulation_entry_type_id == 1
  end

  private

  def validate_apply_from_to_range
    return if apply_from.blank? || apply_to.blank?
    errors.add(:apply_to, 'must be greater than or equal to apply from') unless apply_to >= apply_from
    errors.add(:apply_to, 'must be less than or equal to 5 years later than apply from') unless apply_to <= apply_from.next_year(5)
  end

  def validate_entry_type_change
    errors.add(:simulation_entry_type_id, 'is unable to change') if simulation_entry_type_id_changed?
  end
end
