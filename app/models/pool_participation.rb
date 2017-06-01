class PoolParticipation < ApplicationRecord
  belongs_to :betting_pool
  belongs_to :user_group
  has_one :user, through: :user_group

  alias_attribute :pool, :betting_pool
end
