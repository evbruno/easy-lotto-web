class BettingPool < ApplicationRecord
  belongs_to :group, dependent: :destroy
  has_many :lottery_bets

  alias_attribute :bets, :lottery_bets
end
