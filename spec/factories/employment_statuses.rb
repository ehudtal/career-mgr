FactoryBot.define do
  factory :employment_status do
    sequence(:position){|i| i}
    sequence(:name){|i| "Employment Status #{i}"}
  end
  
  factory :employment_status_unemployed, class: 'EmploymentStatus' do
    position 0
    name 'Unemployed'
  end
end
