FactoryBot.define do
  factory :industry do
    sequence(:name){|i| "Industry#{'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')[i]}"}
  end
end
