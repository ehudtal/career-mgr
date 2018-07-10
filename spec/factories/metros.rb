FactoryBot.define do
  factory :metro do
    sequence(:code) {|i| sprintf("%04d", i * 20)}
    sequence(:name) {|i| "Metro #{i}"}
  end
end
