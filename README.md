# Blackjack (Ruby on Rails)

Single-player Blackjack web app built with Ruby on Rails.

## Requirements

- Ruby 3.x
- Bundler

## Setup and Run

```bash
cd blackjack
bundle install
bin/rails server
```

Open `http://localhost:3000`.

## Core Rules Implemented

- Card values: number cards = face value, J/Q/K = 10, Ace = 1 or 11 with automatic adjustment.
- Correct deal order: player, dealer, player, dealer (second dealer card hidden while player acts).
- Natural blackjack handling and payout (1.5x) with push handling.
- Player actions: hit and stand.
- Immediate player bust resolution.
- Dealer behavior: hits until 17+, stands on 17 (including soft 17 behavior via hand total logic).
- Settlement: win, lose, push, and dealer bust outcomes.

## Additional Features Beyond Core

- Betting before each round.
- Chip tracking across rounds.
- Automatic rebuy to 100 chips when broke (on next round/new game).

## Project Structure

- `app/models/card.rb` - card rank/suit/value helpers.
- `app/models/deck.rb` - deck creation, shuffle, draw.
- `app/models/hand.rb` - hand totals, blackjack/bust checks, ace adjustment.
- `app/models/blackjack_game.rb` - game state and round logic.
- `app/controllers/game_controller.rb` - HTTP actions and session persistence.
- `app/views/game/show.html.erb` - game UI.

## Notes

- No database is required; game state is stored in the Rails session.
