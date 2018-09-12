require 'rails_helper'
require 'feature_helper'

RSpec.feature "SiteViews", type: :feature do
  include FeatureHelper

  let(:site) { create :site }
  let(:location) { create :location, locateable: site, contact: contact }
  let(:contact) { create :contact }
  let(:course) { create :course, site: site, semester: 'Spring', year: 2018 }
  
  background do
    location; course

    expect(Site.count).to eq(1)
    
    login
  end
  
  def visit_sites
    expect(page).to have_content("Sites")
    click_on "Sites"
  end
  
  scenario "Creating", js: true do
    visit_sites
    click_on 'New Site'
    
    expect(page).to have_content('New Site')
    
    fill_in 'site[name]', with: 'New Name'
    fill_in 'site[code]', with: 'ABCX'
    
    fill_in 'site[location_attributes][name]', with: 'Location Name'
    fill_in 'site[location_attributes][contact_attributes][address_1]', with: '123 Way Street'
    fill_in 'site[location_attributes][contact_attributes][city]', with: 'Lincoln'
    select 'NE', from: 'site[location_attributes][contact_attributes][state]'
    fill_in 'site[location_attributes][contact_attributes][postal_code]', with: '68521'
    fill_in 'site[location_attributes][contact_attributes][phone]', with: '402-111-2222'
    fill_in 'site[location_attributes][contact_attributes][email]', with: 'test@example.com'
    fill_in 'site[location_attributes][contact_attributes][url]', with: 'http://example.com'

    click_on 'Create Site'
    
    site = Site.last
    expect(site.name).to eq('New Name')
    expect(site.location.name).to eq('Location Name')
    expect(site.location.contact.address_1).to eq('123 Way Street')
    expect(site.location.contact.city).to eq('Lincoln')
    expect(site.location.contact.state).to eq('NE')
    expect(site.location.contact.postal_code).to eq('68521')
    expect(site.location.contact.phone).to eq('402-111-2222')
    expect(site.location.contact.email).to eq('test@example.com')
    expect(site.location.contact.url).to eq('http://example.com')

    expect(page).to have_current_path(admin_sites_path)
    expect(page).to have_content('successfully created')
  end

  scenario "Viewing", js: true do
    visit_sites

    expect(page).to have_content("Sites")
    expect(page).to have_content("New Site")

    click_on site.name

    expect(page).to have_content(site.name)
    expect(page).to have_content('COURSES')
    expect(page).to have_content('Spring 2018')
  end

  scenario "Updating", js: true do
    visit_sites

    click_on 'Edit'

    expect(page).to have_content('EDITING SITE')

    fill_in 'site[name]', with: 'Updated Name'
    fill_in 'site[location_attributes][name]', with: 'Updated Location Name'
    fill_in 'site[location_attributes][contact_attributes][address_1]', with: '234 Way Street'

    click_on 'Update Site'

    site.reload
    expect(site.name).to eq('Updated Name')
    expect(site.location.name).to eq('Updated Location Name')
    expect(site.location.contact.address_1).to eq('234 Way Street')

    expect(page).to have_current_path(admin_sites_path)
    expect(page).to have_content('successfully updated')
  end

  scenario "Deleting", js: true do
    visit_sites

    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_current_path(admin_sites_path)
    expect(page).to have_content("successfully deleted.")
    expect(Site.count).to eq(0)
  end
end
