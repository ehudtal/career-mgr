FactoryBot.define do
  factory :employment_status do
    sequence(:name){|i| "Employment Status #{i}"}
  end
end
