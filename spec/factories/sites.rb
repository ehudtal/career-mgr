FactoryBot.define do
  factory :site do
    sequence(:name){|i| "Site #{i}"}
  end
end
