require 'spec/factories/ballot'

Factory.define :office do |office|
  office.title               { |n| "President #{n}" }
  office.number_of_positions 1
  office.association         :ballot              
  office.sequence(:position) { |n| n }
end
