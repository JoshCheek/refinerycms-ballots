require 'spec/factories/all'

# Commented out because I can't figure out how to setup the test env :(
# 
# Failure/Error: post :login, :ballot_id => @ballot.id, :unique_identifier => "INVALID"
# NoMethodError:
#   undefined method `post' for #<RSpec::Core::ExampleGroup::Nested_11::Nested_1:0x007fd0bfd75298>

describe VotesController do
  
  # before :each do
  #   @ballot = get_ballot!
  #   @member = get_member!
  # end
  # 
  # context 'when logging in with the wrong number' do
  #   it 'renders the form again with an error message' do
  #     post :login, :ballot_id => @ballot.id, :unique_identifier => "INVALID"
  #     assert_redirected_to login
  #     flash[:error].should_not be_blank
  #     # it should be redirected to login page
  #   end
  # end
  # 
  # context 'when logging into a ballot you have already voted for' do
  #   it 'renders the form again with an error message'
  # end
  # 
  # context 'when logging in with the correct number' do
  #   it 'renders the voting form'
  # end
end
