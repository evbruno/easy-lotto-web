class LotteryBet < ApplicationRecord
  belongs_to :betting_pool, dependent: :destroy
  belongs_to :lottery, dependent: :destroy

  alias_attribute :pool, :betting_pool

  serialize :numbers

  def hits
    draws = Draw.where(lottery: self.lottery, number: (self.first_draw)..(self.last_draw))
    ret = Hash.new
    return ret if draws.empty?

    draws.each do |draw|
      bet_hits = (draw.numbers & self.numbers).count
      min_hits = draw.prizes.keys.min
      ret[draw] = { :hits => bet_hits, :prize => draw.prizes[bet_hits] } if bet_hits >= min_hits
    end

    ret
  end
end
