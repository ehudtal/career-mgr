# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['Agriculture', 'Education', 'Information'].each do |name|
  Industry.create(name: name)
end

['Camping', 'Fishing', 'Hiking'].each do |name|
  Interest.create(name: name)
end

fruits = ['Apples', 'Bananas', 'Carrots', 'Figs', 'Oranges', 'Raspberries', 'Strawberries']

['ABC Employer', 'DEF Employer'].each do |name|
  employer = Employer.create(name: name)
  
  Industry.limit(2).each do |industry|
    employer.industries << industry
  end
  
  3.times do
    fruit = fruits.shift
    employer.opportunities.create name: fruit, description: "Buying and selling #{fruit}"
  end
end