FactoryBot.define do
  factory :course do
    sequence(:semester){|i| Course::VALID_SEMESTERS[i % Course::VALID_SEMESTERS.size]}
    sequence(:year){|i| 2011 + (i / Course::VALID_SEMESTERS.size).to_i}
    
    association :site
  end
end
