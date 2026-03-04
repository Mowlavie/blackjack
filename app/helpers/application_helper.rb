module ApplicationHelper
  # Returns a CSS class for the message banner based on game outcome
  def outcome_class(game)
    return "" unless game.state == "over"

    case game.result[:outcome]
    when :win       then "win"
    when :blackjack then "blackjack"
    when :push      then "push"
    when :lose      then "lose"
    else ""
    end
  end
end
