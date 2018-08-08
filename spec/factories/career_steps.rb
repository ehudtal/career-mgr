FactoryBot.define do
  factory :career_step do
    name 'Name'
    description 'Description'
    
    association :fellow
  end
end
