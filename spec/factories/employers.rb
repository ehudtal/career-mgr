FactoryBot.define do
  factory :employer do
    sequence(:name){|i| "Employer #{i}"}
  end
end
