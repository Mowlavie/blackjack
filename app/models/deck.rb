class Deck
  def initialize
    @cards = Card::SUITS.flat_map do |suit|
      Card::RANKS.map { |rank| Card.new(suit, rank) }
    end.shuffle
  end

  def draw
    @cards.pop
  end

  def size
    @cards.size
  end

  def to_a
    @cards.map(&:to_h)
  end

  def self.from_a(array)
    deck = new
    deck.instance_variable_set(:@cards, array.map { |h| Card.from_h(h) })
    deck
  end
end
