module LotteryHelper

  def self.import_lottery(lottery, path, amount_of_pages)
    puts "> Importing #{lottery.name}, until curr_page #{amount_of_pages}"

    curr_page = 1
    url = "https://easy-lotto-api.herokuapp.com/api/#{path}/"

    Draw.transaction do

      loop do
        response = HTTParty.get(url + curr_page.to_s)
        json_arr = response.parsed_response

        LotteryHelper::create_draws(lottery, json_arr)

        puts "> Importing page #{curr_page}, until page #{amount_of_pages}"

        curr_page += 1

        sleep(2)

        break if curr_page > amount_of_pages

      end # loop

    end # transaction
  end

  private

  def self.create_draws(lottery, json_arr)
    json_arr.each do |json|
      if draw_exists?(lottery, json['draw']) then
        puts "Draw #{json['draw']} exists... skipping !"
      else
        create_draw(lottery, json)
      end
    end
  end

  def self.draw_exists?(lottery, draw_number)
  	Draw.exists?( lottery: lottery, number: draw_number )
  end

  def self.create_draw(lottery, json)
    puts "> Creating Draw #{json['draw']} for #{lottery.name}"

    raw_prizes = json['prizes']
    prizes = Hash[raw_prizes.map { |k, v| [k, parse_money(v)] }]

    Draw.create(lottery: lottery,
                number: json['draw'],
                date: parse_date(json['drawDate']),
                numbers: json['numbers'],
                prizes: prizes)
  end

  def self.parse_date(input)
    Date.strptime(input, '%d/%m/%Y')
  end

  def self.parse_money(input)
    input.gsub('.', '').gsub(',', '.').to_f
  end

end
