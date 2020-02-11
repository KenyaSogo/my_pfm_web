class Item < ApplicationRecord
  belongs_to :user
  has_many :sub_items, dependent: :destroy
end
