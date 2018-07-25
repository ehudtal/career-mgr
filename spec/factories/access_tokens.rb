FactoryBot.define do
  factory :access_token do
    routes [{method: 'GET', path: '/test/this'}]
  end
end
