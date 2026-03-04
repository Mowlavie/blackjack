Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "game#show"

  post "bet",       to: "game#bet",       as: :bet
  post "hit",       to: "game#hit",       as: :hit
  post "stand",     to: "game#stand",     as: :stand
  post "new_game",  to: "game#new_game",  as: :new_game
  post "new_round", to: "game#new_round", as: :new_round
end
