FactoryBot.define do
  factory :comment do
    commentable_id 1
    commentable_type "MyString"
    body "MyText"
  end
end
