FactoryBot.define do
  factory :coach do
    sequence(:name){|i| "Coach #{i}"}
  end
end
