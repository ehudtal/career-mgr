FactoryBot.define do
  factory :fellow_opportunity do
    association :fellow
    association :opportunity
    association :opportunity_stage
  end
end
