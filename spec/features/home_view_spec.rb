require 'rails_helper'

RSpec.feature "404 View" do
  scenario "Seeing the default 404 page" do
    visit '/404.html'
    expect(page.text).to match("doesn't exist")
  end
end