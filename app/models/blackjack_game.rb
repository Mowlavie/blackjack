class BlackjackGame
  attr_reader :deck, :player_hand, :dealer_hand, :state, :message, :chips, :bet

  STATES = %w[betting playing dealer_turn over].freeze

  def initialize(chips: 100)
    @chips = chips
    @bet = 0
    @state = "betting"
    @message = "Place a bet when you're ready."
    @deck = nil
    @player_hand = nil
    @dealer_hand = nil
  end

  def place_bet(amount)
    amount = amount.to_i
    return self if state != "betting"

    if amount < 1
      @message = "Bet must be at least $1."
      return self
    end
    if amount > chips
      @message = "You only have $#{chips} left."
      return self
    end

    @bet = amount
    @chips -= amount
    deal_initial_cards
    self
  end

  def hit
    return self unless state == "playing"

    player_hand.add(deck.draw)
    if player_hand.bust?
      @state = "over"
      @message = "Bust. You went over 21 and lost $#{bet}."
    elsif player_hand.blackjack?
      stand
    else
      @message = "You drew #{player_hand.cards.last.rank}#{player_hand.cards.last.suit}. Total is #{player_hand.total}. Hit or stand?"
    end
    self
  end

  def stand
    return self unless state == "playing"

    @state = "dealer_turn"
    play_dealer
    self
  end

  def result
    return unless state == "over"

    player_total = player_hand.total
    dealer_total = dealer_hand.total

    if player_hand.bust?
      { outcome: :lose, payout: 0 }
    elsif dealer_hand.bust?
      { outcome: :win, payout: bet * 2 }
    elsif player_hand.blackjack? && !dealer_hand.blackjack?
      { outcome: :blackjack, payout: (bet * 2.5).to_i }
    elsif player_total > dealer_total
      { outcome: :win, payout: bet * 2 }
    elsif player_total == dealer_total
      { outcome: :push, payout: bet }
    else
      { outcome: :lose, payout: 0 }
    end
  end

  def to_h
    {
      deck: deck&.to_a,
      player_hand: player_hand&.to_a,
      dealer_hand: dealer_hand&.to_a,
      state: state,
      message: message,
      chips: chips,
      bet: bet
    }
  end

  def self.from_h(hash)
    game = new(chips: hash["chips"].to_i)
    game.instance_variable_set(:@bet, hash["bet"].to_i)
    game.instance_variable_set(:@state, hash["state"])
    game.instance_variable_set(:@message, hash["message"])
    game.instance_variable_set(:@deck, hash["deck"] ? Deck.from_a(hash["deck"]) : nil)
    game.instance_variable_set(:@player_hand, hash["player_hand"] ? Hand.from_a(hash["player_hand"]) : nil)
    game.instance_variable_set(:@dealer_hand, hash["dealer_hand"] ? Hand.from_a(hash["dealer_hand"]) : nil)
    game
  end

  private

  def deal_initial_cards
    @deck = Deck.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new

    2.times do
      player_hand.add(deck.draw)
      dealer_hand.add(deck.draw)
    end

    @state = "playing"

    if player_hand.blackjack?
      stand
    else
      @message = "You have #{player_hand.total}. Dealer shows #{dealer_hand.cards.first.rank}#{dealer_hand.cards.first.suit}. Hit or stand?"
    end
  end

  def play_dealer
    while dealer_hand.total < 17
      dealer_hand.add(deck.draw)
    end

    @state = "over"
    r = result

    @chips += r[:payout]

    @message = case r[:outcome]
    when :blackjack then "Blackjack. You win $#{r[:payout] - bet} (paid 1.5x)."
    when :win
      dealer_hand.bust? ? "Dealer busts. You win $#{r[:payout] - bet}." : "You win, #{player_hand.total} beats #{dealer_hand.total}. +$#{r[:payout] - bet}."
    when :push      then "Push. It's a tie, so your $#{bet} bet is returned."
    when :lose      then "Dealer wins with #{dealer_hand.total} over #{player_hand.total}. You lose $#{bet}."
    end
  end
end
