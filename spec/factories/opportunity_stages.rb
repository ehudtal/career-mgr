FactoryBot.define do
  factory :opportunity_stage do
    sequence(:name){|i| "Opportunity Stage #{i}"}
    probability ".95"
  end
end
