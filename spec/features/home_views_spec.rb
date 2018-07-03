require 'rails_helper'

RSpec.feature "HomeViews", type: :feature do
  scenario "Viewing the homepage" do
    visit '/'

    expect(page.text).to include("Fellows")
    expect(page.text).to include("Employers")
    expect(page.text).to include("Opportunities")
    expect(page.text).to include("Industries")
    expect(page.text).to include("Interests")
    expect(page.text).to include("Sites")
    
    expect(page).to have_css('a.button[href="/home/new_opportunity"]')
  end
end
