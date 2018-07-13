def login
  create :user, email: 'admin@beyondz.org' unless User.find_by(email: 'admin@beyondz.org')
  visit root_path
  
  begin
    find('a[href="/users/sign_out_sso"]')
  rescue Capybara::ElementNotFound
    fill_in 'username', with: 'admin@beyondz.org'
    fill_in 'password', with: 'test1234'
  
    click_on 'Log in'
  end
end
