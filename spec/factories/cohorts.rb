FactoryBot.define do
  factory :cohort do
    sequence(:name){|i| "Cohort #{i}"}
    
    association :course
  end
end
