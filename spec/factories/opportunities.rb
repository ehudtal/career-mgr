FactoryBot.define do
  factory :opportunity do
    name "Opportunity"
    association :employer
  end
end
