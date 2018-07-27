FactoryBot.define do
  factory :opportunity do
    sequence(:name) {|i| "Opportunity #{i}"}
    description "Description"
    job_posting_url "https://example.com"
    association :employer
  end
end
