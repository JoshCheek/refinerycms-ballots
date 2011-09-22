require 'spec/factories/ballot'

def get_candidate(options={})
  Factory.build :candidate, options
end

def get_candidate!(options={})
  candidate = get_candidate options
  candidate.save!
  candidate
end

Factory.define :candidate do |candidate|
  candidate.sequence(:name)       { |n| "Election #{n}" }
  candidate.association(:office)
  candidate.sequence(:position)   { |n| n }  
end
