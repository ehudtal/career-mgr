['Unemployed', 'Quality (Grad School)', 'Quality', 'Part Quality', 'Not Quality', 'Service', 'Unknown'].each_with_index do |status, position|
  EmploymentStatus.find_or_create_by name: status, position: position
end

nlu = Site.find_or_create_by code: 'NLU', name: 'National Louis University'
nlu.update(
  location_attributes: {
    name: 'Chicago Campus',
    contact_attributes: {
      address_1: '122 S Michigan Ave',
      city: 'Chicago', state: 'IL', postal_code: '60603',
      phone: '888-658-8632',
      email: 'nluchicago@nl.edu',
      url: 'http://www.nl.edu'
    }
  }
)

rutgers = Site.find_or_create_by code: 'RU-N', name: "Rutgers University - Newark"
rutgers.update(
  location_attributes: {
    name: 'Office of the Chancellor',
    contact_attributes: {
      address_1: '123 Washington ',
      city: 'Neward', state: 'NJ', postal_code: '07102',
      phone: '973-353-5541',
      url: 'http://www.neward.rutgers.edu'
    }
  }
)

sjsu = Site.find_or_create_by code: 'SJSU', name: 'San Jose State University'
sjsu.update(
  location_attributes: {
    name: 'Campus',
    contact_attributes: {
      address_1: 'One Washington Square',
      city: 'San Jose', state: 'CA', postal_code: '95192',
      phone: '408-924-1000',
      url: 'http://www.sjsu.edu'
    }
  }
)
