module LotteryHelper

  def self.import_lottery(lottery, path, amount_of_pages)
    puts "> Importing #{lottery.name}, until curr_page #{amount_of_pages}"

    curr_page = 0
    url = "https://easy-lotto-api.herokuapp.com/api/#{path}/"

    Draw.transaction do

      loop do
        response = HTTParty.get(url + curr_page.to_s)
        json_arr = response.parsed_response

        LotteryHelper::create_draws(lottery, json_arr)

        curr_page += 1

        puts "> Importing page #{curr_page}, until page #{amount_of_pages}"

        sleep(2)

        break if curr_page >= amount_of_pages

      end # loop

    end # transaction
  end

  private

  def self.create_draws(lottery, json_arr)
    json_arr.each do |json|
      if draw_exists?(lottery, json['draw']) then
        ptus "Draw #{json['draw']} exists... skiping !"
      else
        draw = create_draw(lottery, json)
        create_draw_prize(draw, json)
      end
    end
  end

  def self.draw_exists?(lottery, draw_number)
  	Draw.exists?( lottery: lottery, number: draw_number )
  end

  def self.create_draw(lottery, json)
    puts "> Creating Draw for #{lottery.inspect}"
    Draw.create(lottery: lottery,
                number: json['draw'],
                date: parse_date(json['drawDate']),
                numbers: json['numbers'])
  end

  def self.create_draw_prize(draw, json)
    puts "> Creating DrawPrizes for #{draw.lottery.name} > #{draw.number}"
    json['prizes'].each do | arr |
      DrawPrize.create(draw: draw,
                       numbers: arr[0],
                       value: parse_money(arr[1]))
    end
  end

  def self.parse_date(input)
    Date.strptime(input, '%d/%m/%Y')
  end

  def self.parse_money(input)
    input.gsub('.', '').gsub(',', '.').to_f
  end

end
