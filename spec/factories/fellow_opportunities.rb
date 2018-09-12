FactoryBot.define do
  factory :fellow_opportunity do
    association :fellow
    association :opportunity
    association :opportunity_stage
    
    active true
  end
end
