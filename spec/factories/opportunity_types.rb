FactoryBot.define do
  factory :opportunity_type do
    sequence(:name) { |i| "Opportunity Type #{sprintf('%02d', i)}"}
    sequence(:position) { |i| i }
  end
end
