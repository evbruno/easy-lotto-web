class Lottery < ApplicationRecord
  has_many :draws, dependent: :destroy
end
