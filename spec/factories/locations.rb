FactoryBot.define do
  factory :location do
    sequence(:name){|i| "Location #{i}"}
  end
end
