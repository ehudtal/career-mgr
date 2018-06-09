FactoryBot.define do
  factory :task do
    name "Task"
    due_at { Time.now + 5.days }
  end
end
