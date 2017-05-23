class UserGroup < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :group, dependent: :destroy
  has_many :user_balance_entries
end
