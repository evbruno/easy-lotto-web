class Draw < ApplicationRecord
  belongs_to :lottery
  serialize :numbers
  serialize :prizes
end
