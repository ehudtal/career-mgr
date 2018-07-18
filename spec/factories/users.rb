FactoryBot.define do
  factory :user do
    sequence(:email){|i| "user#{i}@example.com"}
    password 'password'
    
    factory :admin_user do
      admin true
      fellow false
    end
    
    factory :fellow_user do
      admin false
      fellow true
    end
  end
end
