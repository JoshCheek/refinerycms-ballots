require 'spec/factories/office'

def get_ballot(options={})
  Factory.build :ballot, options
end

def get_ballot!(options={})
  ballot = get_ballot(options)
  ballot.save!
  ballot
end


Factory.define :ballot do |ballot|
  ballot.sequence(:title)    { |n| "Election #{n}" }
  ballot.sequence(:position) { |n| n }
  ballot.start_date          { 10.days.ago }
  ballot.end_date            { 10.days.from_now }
end
