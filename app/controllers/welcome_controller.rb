class WelcomeController < ApplicationController

  # GET /users
  def index
    # cache it?
    @lotofacil_draws = load_all('Lotofacil')
    @megasena_draws = load_all('Mega Sena')
  end

  private

  def load_all(name)
    l = Lottery.where(name: name).first
    Draw.where(lottery: l).order(number: :desc).limit(7)
  end

end
