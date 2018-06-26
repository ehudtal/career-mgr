FactoryBot.define do
  factory :site do
    sequence(:code){|i| "ABC#{i}"}
    sequence(:name){|i| "Site #{i}"}
  end
end
