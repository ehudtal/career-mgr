FactoryBot.define do
  factory :access_token do
    routes [{method: 'GET', path: '/test/this'}]
    association :owner, factory: :fellow
  end
end
