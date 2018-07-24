module FactoryHelpers
  extend self
  
  def letter_sequence
    @letter_sequence ||= ('a'..'hhh').to_a
  end
end