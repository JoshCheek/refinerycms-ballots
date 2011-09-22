Factory.define :office do |office|
  office.title               { |n| "President #{n}" }
  office.number_of_positions 1
  office.association         :ballot              
  office.sequence(:position) { |n| n }
end

def get_office(options={})
  Factory.build :office, options
end

def get_office!(options={})
  office = get_office options
  office.save!
  office
end
