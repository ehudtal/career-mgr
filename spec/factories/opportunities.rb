FactoryBot.define do
  factory :opportunity do
    sequence(:name) {|i| "Opportunity #{i}"}
    summary "Summary"
    job_posting_url "https://example.com"

    association :employer
    association :opportunity_type
    association :region
    
    after(:build) do |opp, evaluator|
      opp.metros << create(:metro) if opp.metros.empty?
    end
  end
end
