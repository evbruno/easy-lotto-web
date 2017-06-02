class Lottery < ApplicationRecord
  has_many :draws, dependent: :destroy

  def last_draw
    # FIXME cache it ?
    Draw.where(lottery: self).order(number: :desc).first
  end
end
