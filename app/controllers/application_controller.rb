class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :lotofacil
  helper_method :megasena

  def lotofacil
    @@lotofacil ||= Lottery.where(name: 'Lotofacil').first
    @@lotofacil
  end

  def megasena
    @@megasena ||= Lottery.where(name: 'Mega Sena').first
    @@megasena
  end

end
