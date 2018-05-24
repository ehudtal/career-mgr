FactoryBot.define do
  factory :fellow do
    first_name {|i| "Bob#{i}"}
    last_name {|i| "Smith#{i}"}
  end
end
