module BallotsHelper
  def position_message_for(n)
    return "1 position available" if n == 1
    "#{n} positions available"
  end
end