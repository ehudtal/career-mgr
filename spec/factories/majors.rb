FactoryBot.define do
  factory :major do
    sequence(:name) {|i| "Name #{i}" }
  end
end
