require 'lottery_helper'

namespace :importer do

  desc "Import Lotofacil draws"
  task :lotofacil, [:amount_of_pages] => :environment do |task, args|
    amount_of_pages = (args[:amount_of_pages] || 1).to_i
    lottery = Lottery.where(name: 'Lotofacil').first
    LotteryHelper::import_lottery(lottery, 'lotofacil', amount_of_pages)
  end #task

  desc "Import MegaSena draws"
  task :megasena, [:amount_of_pages] => :environment do |task, args|
    amount_of_pages = (args[:amount_of_pages] || 1).to_i
    lottery = Lottery.where(name: 'Mega Sena').first
    LotteryHelper::import_lottery(lottery, 'megasena', amount_of_pages)
  end

end
