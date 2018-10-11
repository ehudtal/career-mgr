require 'rails_helper'
require 'feature_helper'

RSpec.feature "OpportunityViews", type: :feature do
  include FeatureHelper

  let(:opportunity) { create :opportunity }
  
  let(:industry_included) { create :industry }
  let(:industry_excluded) { create :industry }
  let(:interest_included) { create :interest }
  let(:interest_excluded) { create :interest }
  let(:metro_included)    { create :metro }
  let(:metro_excluded)    { create :metro }
  
  background do
    opportunity

    expect(Opportunity.count).to eq(1)
    
    login
  end
  
  def create_taggables
    industry_included; industry_excluded
    interest_included; interest_excluded
    metro_included; metro_excluded
  end
  
  scenario "Creating", js: true do
    create_taggables

    visit_page :opportunities

    click_on 'New Opportunity'
    click_on opportunity.employer.name

    expect(page).to have_content('NEW OPPORTUNITY')

    opportunity_attributes = attributes_for :opportunity

    fill_in 'Opportunity Name or Job Title', with: opportunity_attributes[:name]
    fill_in 'Summary', with: opportunity_attributes[:summary]

    click_on '+add a location'

    contact_attributes = attributes_for :contact

    fill_in 'opportunity[locations_attributes][0][name]', with: 'Headquarters'
    fill_in 'City', with: contact_attributes[:city]
    select contact_attributes[:state], from: 'State'
    fill_in 'Postal code', with: contact_attributes[:postal_code]
    fill_in 'Phone', with: contact_attributes[:phone]
    fill_in 'Email', with: contact_attributes[:email]
    fill_in 'Url', with: contact_attributes[:url]
    fill_in 'opportunity[job_posting_url]', with: opportunity_attributes[:job_posting_url]
    
    expect_list_link_for 'industries/interests', link: 'full list', within: '#interests-collection'
    expect_list_link_for :metro_areas, link: 'full list', within: '#metros-collection'

    add_tag :opportunity, :industry_interest, industry_included.name
    add_tag :opportunity, :industry_interest, interest_included.name
    add_tag :opportunity, :metro, metro_included.name

    click_on 'Create Opportunity'
    opportunity = Opportunity.last
    
    expect(page).to have_content("successfully created")

    [:name, :summary, :job_posting_url].each do |attr|
      expect(opportunity.send(attr)).to eq(opportunity_attributes[attr])
    end

    expect(opportunity.locations.first.name).to eq('Headquarters')

    [:city, :state, :postal_code, :phone, :email, :url].each do |attr|
      expect(opportunity.locations.first.contact.send(attr)).to eq(contact_attributes[attr])
    end

    expect(opportunity.industries).to include(industry_included)
    expect(opportunity.industries).to_not include(industry_excluded)

    expect(opportunity.interests).to include(interest_included)
    expect(opportunity.interests).to_not include(interest_excluded)

    expect(opportunity.metros).to      include(metro_included)
    expect(opportunity.metros).to_not  include(metro_excluded)

    expect(page).to have_current_path(admin_employer_opportunities_path(opportunity.employer))
    expect(page).to have_content('successfully created')
  end

  scenario "Viewing", js: true do
    visit_page :opportunities

    expect(page).to have_content("Opportunities")
    expect(page).to have_content("ADD NEW OPPORTUNITY")

    click_on opportunity.name

    expect(page).to have_content(opportunity.name)
  end

  scenario "Updating", js: true do
    opportunity.industries << industry_included
    opportunity.interests << interest_included
    opportunity.metros << metro_included

    create_taggables

    visit_page :opportunities

    click_on 'Edit'

    expect(page).to have_content('EDITING OPPORTUNITY')

    updated_name = opportunity.name + 'x'
    fill_in 'Opportunity Name or Job Title', with: updated_name

    updated_summary = opportunity.summary + 'x'
    fill_in 'Summary', with: updated_summary
    
    expect_list_link_for 'industries/interests', link: 'full list', within: '#interests-collection'
    expect_list_link_for :metro_areas, link: 'full list', within: '#metros-collection'

    remove_tag :opportunity, :industry_interest, industry_included.name
    add_tag    :opportunity, :industry_interest, industry_excluded.name

    remove_tag :opportunity, :industry_interest, interest_included.name
    add_tag    :opportunity, :industry_interest, interest_excluded.name

    remove_tag :opportunity, :metro, metro_included.name
    add_tag    :opportunity, :metro, metro_excluded.name

    click_on 'Update Opportunity'

    opportunity.reload
    expect(opportunity.name).to eq(updated_name)
    expect(opportunity.summary).to eq(updated_summary)

    expect(opportunity.industries).to include(industry_excluded)
    expect(opportunity.industries).to_not include(industry_included)

    expect(opportunity.interests).to include(interest_excluded)
    expect(opportunity.interests).to_not include(interest_included)

    expect(opportunity.metros).to include(metro_excluded)
    expect(opportunity.metros).to_not include(metro_included)

    expect(page).to have_current_path(admin_employer_opportunities_path(opportunity.employer))
    expect(page).to have_content('successfully updated')
  end

  scenario "Deleting", js: true do
    visit_page :opportunities

    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_current_path(admin_employer_opportunities_path(opportunity.employer))
    expect(page).to have_content("successfully deleted.")
    expect(Opportunity.count).to eq(0)
  end
end
