class User < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :user_balance_entries, :through => :user_groups

  alias_attribute :groups, :user_groups
  alias_attribute :balances, :user_balance_entries

end
