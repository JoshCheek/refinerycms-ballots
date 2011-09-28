module VotesHelper
  include Admin::BallotsHelper
  def undervote_message_for(office_vote)
    "you have voted for #{pluralize office_vote.num_votes, 'candidate', 'candidates'}, " \
      "which is fewer than the #{office_vote.max_num_votes} you could have voted for."
  end
  
  def undervoted?(office_vote)
    office_vote.num_votes < office_vote.max_num_votes
  end
  
  def show_errors_for_ballot_vote(ballot)
    errors = ballot.errors[:base]
    return '' if errors.empty?
    raw "<div class='errorExplanation'><ul>#{errors_as_li errors}</ul></div>"
  end
  
  def show_errors_for_office_vote(office)
    return '' if office.errors.empty?
    raw "<div class='errorExplanation'><ul>#{errors_as_li office.errors.full_messages}</ul></div>"
  end
  
  def errors_as_li(error_messages)
    error_messages.map { |msg| "<li>#{msg}</li>" }.join
  end
end
