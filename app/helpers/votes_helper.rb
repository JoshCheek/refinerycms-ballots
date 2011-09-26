module VotesHelper
  include Admin::BallotsHelper
  def undervote_message_for(office_vote)
    "you have voted for #{pluralize office_vote.num_votes, 'candidate', 'candidates'}, " \
      "which is fewer than the #{office_vote.max_num_votes} you could have voted for."
  end
  
  def undervoted?(office_vote)
    office_vote.num_votes < office_vote.max_num_votes
  end
  
  def show_errors_for(office)
    return '' if office.errors.empty?
    raw "<div class='errorExplanation'>#{errors_as_li office}</div>"
  end
  
  def errors_as_li(office)
    office.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join
  end
end
