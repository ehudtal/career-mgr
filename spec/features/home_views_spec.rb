require 'rails_helper'
require 'feature_helper'

RSpec.feature "HomeViews", type: :feature do
  include FeatureHelper

  describe 'logged in as admin' do
    background do
      login :admin
    end

    scenario "Viewing the homepage", js: true do
      expect(page.text).to include("Fellows")
      expect(page.text).to include("Employers")
      expect(page.text).to include("Opportunities")
      expect(page.text).to include("Industries")
      expect(page.text).to include("Interests")
      expect(page.text).to include("Sites")

      expect(page).to have_css('a.button[href="/admin/home/new_opportunity"]')
    end
  end
  
  describe 'logged in as fellow' do
    background do
      login :fellow
    end
    
    scenario "Viewing the homepage", js: true do
      expect(page).to have_content(/Job Hunter/i)
    end
  end
end
