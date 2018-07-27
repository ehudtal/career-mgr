FactoryBot.define do
  factory :candidate_log do
    status 'interested'
    association :candidate, factory: :fellow_opportunity
  end
end
