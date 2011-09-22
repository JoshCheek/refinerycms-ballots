Factory.define :member do |member|
  member.first_name           "Leonhard"
  member.last_name            "Euler"
  member.email                "euler@projecteuler.net"
  member.sequence(:position)  { |n| n }
  member.unique_identifier    { |n| "2.71828182845904523536028747135266249775724709369995"[0..n] }
end
