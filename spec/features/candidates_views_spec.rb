require 'rails_helper'
require 'feature_helper'

RSpec.feature "Candidate Views", type: :feature do
  include FeatureHelper

  let(:user) { create :admin_user }
  
  let(:contact) { create :contact, contactable: location, postal_code: postal_code.code }
  let(:location) { create :location, locateable: employer }

  let(:postal_code) { create :postal_code, msa_code: metro.code }
  let(:postal_code_other) { create :postal_code, msa_code: metro_other.code }

  let(:industry) { create :industry, name: 'Accounting' }
  let(:industry_other) { create :industry }

  let(:interest) { create :interest, name: 'Accounting' }
  let(:interest_other) { create :interest }
  
  let(:metro) { create :metro }
  let(:metro_other) { create :metro }
  
  let(:employer) { create :employer }
  let(:opportunity) { create :opportunity, employer: employer, metro_ids: [metro.id], opportunity_type: opportunity_type }
  
  let(:fellow) { create :fellow }
  let(:contact_fellow) { create :contact, contactable: fellow, postal_code: postal_code.code }

  let(:fellow_other) { create :fellow }
  let(:contact_fellow_other) { create :contact, contactable: fellow_other, postal_code: postal_code_other.code }
  
  let(:opportunity_stage) { create :opportunity_stage, name: 'First', position: 0, probability: 0.1 }
  let(:opportunity_stage_next) { create :opportunity_stage, name: 'Second', position: 1, probability: 0.2 }
  
  let(:opportunity_type) { create :opportunity_type }
  
  background do
    opportunity_stage; opportunity_stage_next
    contact; contact_fellow; contact_fellow_other
    fellow.reload; fellow_other.reload
    employer.industries << industry
    expect(Metro.count).to eq(2)

    opportunity.industries << industry
    opportunity.interests << interest
    opportunity.locations << location
    expect(Metro.count).to eq(2)
    
    fellow.industries << industry
    fellow.interests << interest
    fellow.metros << metro
    fellow.opportunity_types << opportunity_type
    expect(Metro.count).to eq(2)
    
    fellow_other.industries << industry_other
    fellow_other.interests << interest_other
    fellow_other.metros << metro_other
    fellow_other.opportunity_types << opportunity_type
    expect(Metro.count).to eq(2)
    
    expect(Employer.count).to eq(1)

    expect(employer.industries.count).to eq(1)
    expect(employer.industries).to include(industry)
    expect(employer.opportunities.count).to eq(1)
    expect(employer.opportunities).to include(opportunity)
    
    expect(Opportunity.count).to eq(1)
    
    expect(opportunity.industries.count).to eq(1)
    expect(opportunity.industries).to include(industry)
    expect(opportunity.interests.count).to eq(1)
    expect(opportunity.interests).to include(interest)
    expect(opportunity.metros.count).to eq(1)

    expect(opportunity.metros).to include(metro)
    
    expect(Fellow.count).to eq(2)
    
    expect(fellow.industries.count).to eq(1)
    expect(fellow.industries).to include(industry)
    expect(fellow.interests.count).to eq(1)
    expect(fellow.interests).to include(interest)
    expect(fellow.metros.count).to eq(1)
    expect(fellow.metros).to include(metro)
    
    expect(fellow_other.industries.count).to eq(1)
    expect(fellow_other.industries).to include(industry_other)
    expect(fellow_other.interests.count).to eq(1)
    expect(fellow_other.interests).to include(interest_other)
    expect(fellow_other.metros.count).to eq(1)
    expect(fellow_other.metros).to include(metro_other)
    
    expect(Industry.count).to eq(2)
    expect(Interest.count).to eq(2)

    login
  end
  
  scenario "Searching", js: true do
    visit_page :employers

    click_on employer.name
    expect(page).to have_content(employer.name)

    click_on opportunity.name
    expect(page).to have_content(/Active Candidates/i)
    
    click_on 'Find Candidates'
    expect(page).to have_content(fellow.full_name)
    expect(page).to_not have_content(fellow_other.full_name)

    expect_list_link_for 'industries/interests', link: 'full list', within: '#industry-interest-tags'
    expect_list_link_for :metro_areas, link: 'full list', within: '#metro-tags'

    add_tag :opportunity, :industry_interest, industry_other.name
    remove_tag :opportunity, :metro, metro.name
    expect(page).to have_content(fellow.full_name)
    expect(page).to have_content(fellow_other.full_name)
    
    remove_tag :opportunity, :industry_interest, industry.name
    expect(page).to_not have_content(fellow.full_name)
    expect(page).to have_content(fellow_other.full_name)

    find(:css, "input#candidate_ids_#{fellow_other.id}").set(true)
    click_on 'Notify Candidates'
    expect(page).to have_content(fellow_other.full_name)
    
    fellow_opportunity = FellowOpportunity.last
    expect(fellow_opportunity.opportunity_stage).to eq(opportunity_stage)
    
    select 'Second', from: 'fellow_opportunity_opportunity_stage_id'
    click_on 'Update'
    expect(fellow_opportunity.reload.opportunity_stage).to eq(opportunity_stage_next)
  end
end
