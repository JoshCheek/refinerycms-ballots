require_relative 'ballot'

Factory.define :office do |f|
  f.title               { |n| "President #{n}" }
  f.number_of_positions 1
  f.association         :ballot              
  f.sequence(:position) { |n| n }
end
