class GameController < ApplicationController
  before_action :load_game

  def show
    # renders show.html.erb
  end

  def bet
    amount = params[:amount].to_i
    @game.place_bet(amount)
    save_game
    redirect_to root_path
  end

  def hit
    @game.hit
    collect_winnings_if_over
    save_game
    redirect_to root_path
  end

  def stand
    @game.stand
    collect_winnings_if_over
    save_game
    redirect_to root_path
  end

  def new_game
    session[:game] = nil
    @game = BlackjackGame.new(chips: load_chips)
    save_game
    redirect_to root_path
  end

  def new_round
    chips = @game.chips
    chips = 100 if chips < 1 # re-buy if broke
    session[:game] = nil
    @game = BlackjackGame.new(chips: chips)
    save_game
    redirect_to root_path
  end

  private

  def load_game
    @game = if session[:game]
      BlackjackGame.from_h(session[:game])
    else
      BlackjackGame.new
    end
  end

  def save_game
    session[:game] = @game.to_h
  end

  def load_chips
    @game&.chips || 100
  end

  def collect_winnings_if_over
    # winnings already applied inside BlackjackGame#play_dealer
  end
end
