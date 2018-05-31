FactoryBot.define do
  factory :cohort_fellow do
    grade ".9"
    attendance ".95"
    nps_response 9
    endorsement 9
    professionalism 9
    teamwork 9
    feedback "Great Fellow!"

    association :cohort
    association :fellow
  end
end
