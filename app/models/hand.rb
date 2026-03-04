class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add(card)
    @cards << card
  end

  def total
    sum = cards.sum(&:value)
    # Downgrade aces from 11 to 1 as needed to avoid busting
    aces = cards.count { |c| c.rank == "A" }
    while sum > 21 && aces > 0
      sum -= 10
      aces -= 1
    end
    sum
  end

  def bust?
    total > 21
  end

  def blackjack?
    cards.size == 2 && total == 21
  end

  def to_a
    cards.map(&:to_h)
  end

  def self.from_a(array)
    hand = new
    array.each { |h| hand.add(Card.from_h(h)) }
    hand
  end
end
