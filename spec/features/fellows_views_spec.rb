require 'rails_helper'
require 'feature_helper'

RSpec.feature "FellowViews", type: :feature do
  include FeatureHelper

  let(:fellow) { create :fellow, employment_status: employment_status }
  let(:contact) { create :contact, contactable: fellow }
  let(:employment_status) { create :employment_status, name: 'Unknown' }
  
  let(:industry_included) { create :industry }
  let(:industry_excluded) { create :industry }
  let(:interest_included) { create :interest }
  let(:interest_excluded) { create :interest }
  let(:metro_included)    { create :metro }
  let(:metro_excluded)    { create :metro }
  
  background do
    fellow; contact; fellow.reload

    expect(Fellow.count).to eq(1)
    
    login
  end
  
  def visit_fellows
    expect(page).to have_content("Fellows")
    click_on "Fellows"
  end
  
  def create_taggables
    industry_included; industry_excluded
    interest_included; interest_excluded
    metro_included; metro_excluded
  end
  
  scenario "Creating", js: true do
    create_taggables

    visit_fellows
    click_on 'New Fellow'

    expect(page).to have_content('New Fellow')
    
    fellow_attributes = attributes_for :fellow

    fill_in 'First name', with: fellow_attributes[:first_name]
    fill_in 'Last name', with: fellow_attributes[:last_name]
    fill_in 'Graduation year', with: fellow_attributes[:graduation_year]
    select fellow_attributes[:graduation_semester], from: 'Graduation term'
    
    contact_attributes = attributes_for :contact
    
    fill_in 'City', with: contact_attributes[:city]
    select contact_attributes[:state], from: 'State'
    fill_in 'Postal code', with: contact_attributes[:postal_code]
    fill_in 'Phone', with: contact_attributes[:phone]
    fill_in 'Email', with: contact_attributes[:email]
    fill_in 'Url', with: contact_attributes[:url]

    expect_list_link_for 'industries/interests', link: 'full list', within: '#interests-collection'
    expect_list_link_for :metro_areas, link: 'full list', within: '#metros-collection'
    
    add_tag :fellow, :industry_interest, industry_included.name
    add_tag :fellow, :industry_interest, interest_included.name
    add_tag :fellow, :metro, metro_included.name

    click_on 'Create Fellow'

    fellow = Fellow.last
    
    [:first_name, :last_name, :graduation_year, :graduation_semester].each do |attr|
      expect(fellow.send(attr)).to eq(fellow_attributes[attr])
    end

    [:city, :state, :postal_code, :phone, :email, :url].each do |attr|
      expect(fellow.contact.send(attr)).to eq(contact_attributes[attr])
    end
    
    expect(fellow.industries).to include(industry_included)
    expect(fellow.industries).to_not include(industry_excluded)

    expect(fellow.interests).to include(interest_included)
    expect(fellow.interests).to_not include(interest_excluded)

    expect(fellow.metros).to      include(metro_included)
    expect(fellow.metros).to_not  include(metro_excluded)

    expect(page).to have_current_path(admin_fellows_path)
    expect(page).to have_content('successfully created')
  end

  scenario "Viewing", js: true do
    visit_fellows

    expect(page).to have_content("Fellows")
    expect(page).to have_content("New Fellow")

    click_on fellow.full_name

    expect(page).to have_content(fellow.full_name)
  end

  scenario "Updating", js: true do
    create_taggables

    visit_fellows

    click_on 'Edit'

    expect(page).to have_content(/Editing Fellow/i)

    updated_first = fellow.first_name + 'x'
    fill_in 'First name', with: updated_first
    
    updated_last = fellow.last_name + 'x'
    fill_in 'Last name', with: updated_last
    
    updated_city = fellow.contact.city + 'x'
    fill_in 'City', with: updated_city

    expect_list_link_for 'industries/interests/majors', link: 'full list', within: '#interests-collection'
    expect_list_link_for :metro_areas, link: 'full list', within: '#metros-collection'

    click_on 'Update Fellow'

    fellow.reload
    expect(fellow.first_name).to eq(updated_first)
    expect(fellow.last_name).to eq(updated_last)
    expect(fellow.contact.city).to eq(updated_city)

    expect(page).to have_current_path(admin_fellows_path)
    expect(page).to have_content('successfully updated')
  end

  scenario "Deleting", js: true do
    visit_fellows

    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_current_path(admin_fellows_path)
    expect(page).to have_content("successfully deleted.")
    expect(Fellow.count).to eq(0)
  end
end
