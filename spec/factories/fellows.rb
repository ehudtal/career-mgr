FactoryBot.define do
  factory :fellow do
    sequence(:first_name){|i| "Bob#{i}"}
    sequence(:last_name){|i| "Smith#{i}"}
    
    association :employment_status
  end
end
