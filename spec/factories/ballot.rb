def get_ballot(options={})
  Factory.build :ballot, options
end

def get_ballot!(options={})
  ballot = get_ballot(options)
  ballot.save!
  ballot
end


Factory.define :ballot do |ballot|
  ballot.sequence(:title)    { |n| "Election #{n}-#{rand}" }
  ballot.sequence(:position) { |n| n }
  ballot.start_date          { 10.days.ago }
  ballot.end_date            { 10.days.from_now }
end

def Factory.create_whole_ballot
  Ballot.create Factory.attributes_for(:ballot, :title=>"2012 election",
                 "offices_attributes"=>
                  {"0"=>
                    Factory.attributes_for(:office, :title=>"President", :number_of_positions=>1,
                                                     "candidates_attributes"=>
                                                      {"0"=>Factory.attributes_for(:candidate, :name=>"Bradford"),
                                                       "1316013000645"=>Factory.attributes_for(:candidate, :name=>"Gary")}),
                   "1316013014442"=>
                    Factory.attributes_for(:office, :title=>"Vice President", :number_of_positions=>1,
                                                     "candidates_attributes"=>
                                                      {"0"=>Factory.attributes_for(:candidate, :name=>"Jim"),
                                                       "1316013025758"=>Factory.attributes_for(:candidate, :name=>"Cara")}),
                   "1316013254746"=>
                    Factory.attributes_for(:office, :title=>"Board of Directors", :number_of_positions=>2,
                                                     "candidates_attributes"=>
                                                      {"0"=>Factory.attributes_for(:candidate, :name=>"Joe"),
                                                       "1316013264883"=>Factory.attributes_for(:candidate, :name=>"Bob"),
                                                       "1316013267758"=>Factory.attributes_for(:candidate, :name=>"Pete"),
                                                       "1316013271569"=>Factory.attributes_for(:candidate, :name=>"Uma")})})
  Ballot.last
end
