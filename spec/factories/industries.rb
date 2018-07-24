require "#{Rails.root}/spec/factory_helpers"

FactoryBot.define do
  factory :industry do
    sequence(:name){|i| "Industry#{FactoryHelpers.letter_sequence[i]}"}
  end
end
