FactoryBot.define do
  factory :opportunity do
    name "Opportunity"
    description "Description"
    job_posting_url "https://example.com"
    association :employer
  end
end
