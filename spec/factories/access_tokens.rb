FactoryBot.define do
  factory :access_token do
    routes [{method: 'GET', params: {}}]
    association :owner, factory: :fellow
  end
end
