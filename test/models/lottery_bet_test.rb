require 'test_helper'

class LotteryBetTest < ActiveSupport::TestCase

  test "bet can calculate its hits" do
    draw1 = draws(:megasena_1932)

    assert_equal 38379.16, draw1.prizes[5]

    hits1 = lottery_bets(:mega_1).hits

    assert_equal 1, hits1.size
    assert_equal 5, hits1.values.first[:hits]
    assert_equal 38379.16, hits1.values.first[:prize]

    hits2 = lottery_bets(:mega_2).hits

    assert_equal 0, hits2.size
  end

end
