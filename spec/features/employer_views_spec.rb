require 'rails_helper'

RSpec.feature "Employer Views", type: :feature do
  let(:employer) { create :employer }
  let(:industry) { create :industry }

  background do
    employer.industries << industry

    expect(Employer.count).to eq(1)
    expect(Industry.count).to eq(1)
    expect(Employer.last.industries).to include(industry)
  end
  
  def visit_employers
    visit '/'
    save_page 'home.html'
    
    expect(page).to have_content("Employers")
    click_on "Employers"
    save_page 'employers.html'
  end
  
  scenario "Viewing" do
    visit_employers
    
    expect(page).to have_content("Employers")
    expect(page).to have_content("Add New Employer")
    
    click_on employer.name
    
    expect(page).to have_content('Industries')
    
    within 'li' do
      expect(page).to have_content(industry.name)
    end
    
    expect(page).to have_content('Opportunities')
    expect(page).to have_content('Locations')
  end
  
  scenario "Updating", js: true do
    visit_employers

    click_on 'Edit'
    
    expect(page).to have_content('Editing Employer')
    
    fill_in 'Name', with: 'New Name'
    click_on 'Update Employer'
    
    expect(employer.reload.name).to eq('New Name')
    expect(page).to have_current_path(employer_path(employer.id))
  end
end
