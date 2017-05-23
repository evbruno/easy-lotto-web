# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Draw.delete_all
Lottery.delete_all

lotofacil = Lottery.create!(name: 'Lotofacil')

Draw.create!(lottery: lotofacil,
              number: 1512,
              date: Time.mktime(2017, 5, 17),
              numbers: [2, 3, 4, 6, 10, 11, 12, 13, 15, 16, 17, 19, 21, 22, 24],
              prizes: {
                15 => 2007937.94,
                14 => 1382.16,
                13 => 20,
                12 => 8,
                11 => 4
                }
              )

mega = Lottery.create!(name: 'Mega Sena')

Draw.create!(lottery: mega,
              number: 1932,
              date: Time.mktime(2017, 5, 20),
              numbers: [10, 16, 21, 29, 44, 55],
              prizes: {
                6 => 0,
                5 => 38379.16,
                4 => 724.45
                }
              )

group = Group.create!(name: 'Default Group')
bob = User.create!(name: 'Bob')
ug = UserGroup.create!(user: bob, group: group)
