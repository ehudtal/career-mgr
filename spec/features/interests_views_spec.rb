require 'rails_helper'
require 'feature_helper'

RSpec.feature "InterestViews", type: :feature do
  include FeatureHelper

  let(:interest) { create :interest }
  
  background do
    interest

    expect(Interest.count).to eq(1)
    
    login
  end
  
  def visit_interests
    expect(page).to have_content("Interests")
    click_on "Interests"
  end
  
  scenario "Creating", js: true do
    visit_interests
    click_on 'Add New Interest'
    
    expect(page).to have_content('NEW INTEREST')
    
    fill_in 'Name', with: 'New Name'
    fill_in 'Description', with: 'New Description'
    
    click_on 'Create Interest'
    
    interest = Interest.last
    expect(interest.name).to eq('New Name')
    expect(interest.description).to eq('New Description')

    expect(page).to have_current_path(admin_interests_path)
    expect(page).to have_content('successfully created')
  end

  scenario "Viewing", js: true do
    visit_interests
    
    expect(page).to have_content("Interests")
    expect(page).to have_content("ADD NEW INTEREST")
    
    click_on interest.name
    expect(page).to have_content(interest.name)
  end

  scenario "Updating", js: true do
    visit_interests

    click_on 'Edit'
    
    expect(page).to have_content('EDITING INTEREST')
    
    fill_in 'Name', with: 'Updated Name'
    fill_in 'Description', with: 'Updated Description'

    click_on 'Update Interest'
    
    interest.reload
    expect(interest.name).to eq('Updated Name')
    expect(interest.description).to eq('Updated Description')

    expect(page).to have_current_path(admin_interests_path)
    expect(page).to have_content('successfully updated')
  end
  
  scenario "Deleting", js: true do
    visit_interests
    
    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept
    
    expect(page).to have_current_path(admin_interests_path)
    expect(page).to have_content("Interest #{interest.name} was successfully deleted.")
    expect(Interest.count).to eq(0)
  end
end
