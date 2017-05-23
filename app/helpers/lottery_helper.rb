class LotteryHelper
  include HTTParty
  format :json

  base_uri 'https://easy-lotto-api.herokuapp.com/api'

  def self.import_lottery(lottery, path, amount_of_pages = 1)
    puts "> Importing #{lottery.name}, until curr_page #{amount_of_pages}"

    curr_page = 1
    helper = self.new

    Draw.transaction do

      loop do
        json_arr = helper.draws(path, curr_page)

        helper.create_draws(lottery, json_arr)

        puts "> Importing page #{curr_page}, until page #{amount_of_pages}"

        curr_page += 1

        if ! Rails.env.test?
          sleep(2)
        end

        break if curr_page > amount_of_pages

      end # loop

    end # transaction
  end

  def lotofacil(page = 1)
    draws('lotofacil', page)
  end

  def megasena(page = 1)
    draws('megasena', page)
  end

  def draws(game, page = 1)
    self.class.get("/#{game}/#{page}")
  end

  def create_draws(lottery, json_arr)
    json_arr.each do |json|
      if draw_exists?(lottery, json['draw']) then
        puts "Draw #{json['draw']} exists... skipping !"
      else
        create_draw(lottery, json)
      end
    end
  end

  private

  def draw_exists?(lottery, draw_number)
    Draw.exists?( lottery: lottery, number: draw_number )
  end

  def create_draw(lottery, json)
    puts "> Creating Draw #{json['draw']} for #{lottery.name}"

    raw_prizes = json['prizes']
    prizes = Hash[raw_prizes.map { |k, v| [k, parse_money(v)] }]

    Draw.create(lottery: lottery,
                number: json['draw'],
                date: parse_date(json['drawDate']),
                numbers: json['numbers'],
                prizes: prizes)
  end

  def parse_date(input)
    Date.strptime(input, '%d/%m/%Y')
  end

  def parse_money(input)
    input.gsub('.', '').gsub(',', '.').to_f
  end

end
