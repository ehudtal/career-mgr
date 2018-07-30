FactoryBot.define do
  factory :fellow do
    sequence(:first_name){|i| "Bob#{i}"}
    sequence(:last_name){|i| "Smith#{i}"}
    
    sequence(:graduation_semester){|i| Course::VALID_SEMESTERS[i % Course::VALID_SEMESTERS.size]}
    sequence(:graduation_year){|i| 2011 + ((i / Course::VALID_SEMESTERS.size).to_i % 35)}
    
    association :employment_status
  end
end
