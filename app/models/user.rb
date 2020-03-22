class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_encrypted :pfm_account_password, key: 'pfm_account_password_key_encrypt'

  has_many :assets, dependent: :destroy
  belongs_to :current_asset, class_name: 'Asset'
  belongs_to :current_simulation, class_name: 'Simulation'

  validates :user_name, presence: true, uniqueness: true
end
