require 'rails_helper'
require 'feature_helper'

RSpec.feature "IndustriesViews", type: :feature do
  include FeatureHelper

  let(:industry) { create :industry }
  
  background do
    industry

    expect(Industry.count).to eq(1)
    
    login
  end
  
  def visit_industries
    expect(page).to have_content(/Industries/i)
    click_on "Industries"
  end
  
  scenario "Creating", js: true do
    visit_industries
    click_on 'Add New Industry'
    
    expect(page).to have_content(/New Industry/i)
    
    fill_in 'Name', with: 'New Name'
    fill_in 'Description', with: 'New Description'
    
    click_on 'Create Industry'
    
    industry = Industry.last
    expect(industry.name).to eq('New Name')
    expect(industry.description).to eq('New Description')

    expect(page).to have_current_path(admin_industries_path)
    expect(page).to have_content('successfully created')
  end

  scenario "Viewing", js: true do
    visit_industries
    
    expect(page).to have_content(/Industries/i)
    expect(page).to have_content("ADD NEW INDUSTRY")
    
    click_on industry.name
    expect(page).to have_content(industry.name)
  end

  scenario "Updating", js: true do
    visit_industries

    click_on 'Edit'
    
    expect(page).to have_content('EDITING INDUSTRY')
    
    fill_in 'Name', with: 'Updated Name'
    fill_in 'Description', with: 'Updated Description'

    click_on 'Update Industry'
    
    industry.reload
    expect(industry.name).to eq('Updated Name')
    expect(industry.description).to eq('Updated Description')

    expect(page).to have_current_path(admin_industries_path)
    expect(page).to have_content('successfully updated')
  end
  
  scenario "Deleting", js: true do
    visit_industries
    
    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept
    
    expect(page).to have_current_path(admin_industries_path)
    expect(page).to have_content("Industry #{industry.name} was successfully deleted.")
    expect(Industry.count).to eq(0)
  end
end
