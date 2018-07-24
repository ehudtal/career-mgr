FactoryBot.define do
  factory :contact do
    address_1 "123 Way Street"
    address_2 "#123"
    city "AnyTown"
    state "NE"
    postal_code "12345"
    phone "555-555-5555"
    email "contact@example.com"
    url "http://example.com"
    
    association :contactable, factory: :fellow
  end
end
