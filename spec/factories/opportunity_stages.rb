FactoryBot.define do
  factory :opportunity_stage do
    sequence(:name){|i| "Opportunity Stage #{i}"}
    sequence(:position){|i| i}
    probability ".95"
    active_status true
  end
end
