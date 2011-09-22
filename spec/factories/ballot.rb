require_relative 'office'

Factory.define :ballot do |ballot|
  ballot.sequence(:title)    { |n| "Election #{n}" }
  ballot.sequence(:position) { |n| n }
  ballot.start_date          { 10.days.ago }
  ballot.end_date            { 10.days.from_now }
end
