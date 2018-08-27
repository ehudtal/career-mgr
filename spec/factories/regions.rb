FactoryBot.define do
  factory :region do
    sequence(:name) { |i| "Region #{i}" }
    sequence(:position) { |i| i }
  end
end
