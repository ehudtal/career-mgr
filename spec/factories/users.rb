FactoryBot.define do
  factory :user do
    sequence(:email){|i| "user#{i}@example.com"}
    password 'password'
    
    factory :admin_user do
      is_admin true
      is_fellow false
    end
    
    factory :fellow_user do
      is_admin false
      is_fellow true
      
      association :fellow
    end
  end
end
