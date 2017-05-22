class Draw < ApplicationRecord
  belongs_to :lottery
  serialize :numbers
end
