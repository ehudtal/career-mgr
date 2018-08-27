FactoryBot.define do
  factory :region do
    sequence(:name) { |i| "Region #{i}" }
  end
end
