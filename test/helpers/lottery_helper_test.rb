require 'test_helper'

class LotteryHelperTest < ActiveSupport::TestCase

  test "helper create_draws" do

    VCR.use_cassette("lotofacil_page1") do
      lotofacil = lotteries(:lotofacil)

      assert_not Draw.exists?(number: 1513, lottery: lotofacil)

      subject = LotteryHelper.new
      json_arr = subject.lotofacil(page = 1)
      subject.create_draws(lotofacil, json_arr)

      assert Draw.exists?(number: 1513, lottery: lotofacil)
      assert Draw.exists?(number: 1512, lottery: lotofacil)
      assert Draw.exists?(number: 1511, lottery: lotofacil)
      assert Draw.exists?(number: 1510, lottery: lotofacil)
      assert Draw.exists?(number: 1509, lottery: lotofacil)

      draw = Draw.where(number: 1509, lottery: lotofacil).first

      assert_equal "2017-05-10", draw.date.to_s
      assert_equal [1, 2, 3, 6, 7, 8, 9, 13, 14, 15, 17, 18, 19, 22, 24], draw.numbers
      assert_equal 332578.98, draw.prizes[15]
      assert_equal 1009.58, draw.prizes[14]
      assert_equal 20, draw.prizes[13]
      assert_equal 8, draw.prizes[12]
      assert_equal 4.0, draw.prizes[11]

      amount_of_draws = Draw.all.count

      assert amount_of_draws >= 5

      subject.create_draws(lotofacil, json_arr)

      assert_equal amount_of_draws, Draw.all.count
    end

  end

  test "helper import lottery pages" do

    VCR.use_cassette("lotofacil_page1") do
      lotofacil = lotteries(:lotofacil)

      assert_not Draw.exists?(number: 1513, lottery: lotofacil)

      LotteryHelper::import_lottery(lotofacil, 'lotofacil', 1)

      draw = Draw.where(number: 1513, lottery: lotofacil).first

      assert_equal "2017-05-19", draw.date.to_s
      assert_equal [3, 4, 6, 7, 9, 10, 11, 12, 13, 14, 16, 18, 21, 22, 24], draw.numbers
      assert_equal 1931178.44, draw.prizes[15]
    end

  end

end
