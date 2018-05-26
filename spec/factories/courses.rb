FactoryBot.define do
  factory :course do
    semester "Fall"
    sequence(:year){|i| 2018 + i}
    
    association :site
  end
end
