module NavigationHelpers
  module Refinery
    module Ballots
      def path_to(page_name)
        case page_name
        when /the list of ballots/
          admin_ballots_path
        when /the login vote page/, /the vote login page/
          login_ballot_votes_path Ballot.last
        when /the new vote page/
          new_ballot_vote_path Ballot.last
        when /the new ballot form/
          new_admin_ballot_path
        else
          nil
        end
      end
    end
  end
end
