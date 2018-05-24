FactoryBot.define do
  factory :course do
    semester "Fall"
    year 2018
    
    association :site
  end
end
