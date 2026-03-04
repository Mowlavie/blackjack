class Card
  SUITS = %w[♠ ♥ ♦ ♣].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def value
    if %w[J Q K].include?(rank)
      10
    elsif rank == "A"
      11
    else
      rank.to_i
    end
  end

  def red?
    suit == "♥" || suit == "♦"
  end

  def to_h
    { suit: suit, rank: rank }
  end

  def self.from_h(hash)
    new(hash["suit"] || hash[:suit], hash["rank"] || hash[:rank])
  end
end
