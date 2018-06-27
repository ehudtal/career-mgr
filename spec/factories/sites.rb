FactoryBot.define do
  factory :site do
    sequence(:code){|i| "ABC#{i}"}
    sequence(:name){|i| "Site #{i}"}
  end
  
  factory :site_sjsu, class: 'Site' do
    code "SJSU"
    name "San Jose State University"
  end
  
  factory :site_run, class: 'Site' do
    code "RU-N"
    name "Rutgers University - Newark"
  end
  
  factory :site_nlu, class: 'Site' do
    code 'NLU'
    name "National Louis University"
  end
end
