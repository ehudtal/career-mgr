# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# remove all existing objects to start fresh!
[Employer, Opportunity, OpportunityStage, Fellow].each(&:destroy_all)

industry_accounting = Industry.find_by name: 'Accounting'
interest_accounting = Interest.find_by name: 'Accounting'

if Metro.count == 0
  metros = Metro.create([
    {code: '4360', name: 'Lincoln, NE'},
    {code: '5920', name: 'Omaha, NE-IA'},
    {code: '7720', name: 'Sioux City, IA-NE'}
  ])
end

lincoln_ne = Metro.find_by name: 'Lincoln, NE'

fruits = ['Apples', 'Bananas', 'Carrots', 'Figs', 'Oranges', 'Raspberries', 'Strawberries']

['ABC Employer', 'DEF Employer'].each do |name|
  employer = Employer.create!(name: name)

  location = employer.locations.create(
    name: "#{employer.name} Headquarters",
    contact_attributes: {city: 'Lincoln', state: 'NE', postal_code: '68516'}
  )
  
  Industry.where.not(name: 'Accounting').limit(2).each do |industry|
    employer.industries << industry
  end
  
  employer.industries << industry_accounting
  
  3.times do
    fruit = fruits.shift
    opportunity = employer.opportunities.create! name: fruit, description: "Buying and selling #{fruit}"

    opportunity.industries << industry_accounting
    opportunity.interests << interest_accounting
    opportunity.locations << location
    opportunity.metros << lincoln_ne
  end
end

opportunity_stages = OpportunityStage.create!([
  {position: 0, probability: 0.01, name: 'notified'},
  {position: 1, probability: 0.05, name: 'interested'},
  {position: 2, probability: 0.0,  name: 'not interested'},
  {position: 3, probability: 0.1,  name: 'applying'},
  {position: 4, probability: 0.15, name: 'application submitted'},
  {position: 5, probability: 0.35, name: 'interview scheduled'},
  {position: 6, probability: 0.55, name: 'interview completed'},
  {position: 7, probability: 0.95, name: 'accepted'},
  {position: 8, probability: 1.0,  name: 'committed'},
  {position: 9, probability: 0.0,  name: 'rejected'}
])

employment_status = EmploymentStatus.order('position asc').first

fellows = Fellow.create!([
  {first_name: 'Andy',  last_name: 'Anderson', graduation_semester: 'Spring', graduation_year: '2018', employment_status_id: employment_status.id, contact_attributes: {postal_code: '68005'}, gpa: 3.0, efficacy_score: 0.95},
  {first_name: 'Beth',  last_name: 'Barstow',  graduation_semester: 'Fall',   graduation_year: '2018', employment_status_id: employment_status.id, contact_attributes: {postal_code: '68510'}, gpa: 3.2, efficacy_score: 0.9},
  {first_name: 'Cole',  last_name: 'Coleman',  graduation_semester: 'Spring', graduation_year: '2019', employment_status_id: employment_status.id, contact_attributes: {postal_code: '68521'}, gpa: 3.4, efficacy_score: 0.85},
  {first_name: 'Debra', last_name: 'Davis',    graduation_semester: 'Fall',   graduation_year: '2019', employment_status_id: employment_status.id, contact_attributes: {postal_code: '68339'}, gpa: 3.6, efficacy_score: 0.8},
  {first_name: 'Ethan', last_name: 'Eberly',   graduation_semester: 'Spring', graduation_year: '2020', employment_status_id: employment_status.id, contact_attributes: {postal_code: '66215'}, gpa: 3.8, efficacy_score: 0.75},
])

# give each fellow three interests
Interest.where.not(name: 'Accounting').limit(fellows.size * 3).each_with_index do |interest, f|
  fellows[f % fellows.size].interests << interest
end

# give each fellow three industries
Industry.where.not(name: 'Accounting').limit(fellows.size * 3).each_with_index do |industry, f|
  fellows[f % fellows.size].industries << industry
end

# give each fellow one metro area (Lincoln, NE)
fellows.each{|f| f.metros << lincoln_ne}

# add all fellows to accounting industry/interest groups
Fellow.all.each do |fellow|
  fellow.industries << industry_accounting
  fellow.interests << interest_accounting
end