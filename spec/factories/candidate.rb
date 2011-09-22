require 'spec/factories/ballot'

Factory.define :candidate do |candidate|
  candidate.sequence(:name)       { |n| "Election #{n}" }
  candidate.association(:office)
  candidate.sequence(:position)   { |n| n }  
end
