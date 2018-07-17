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

def remove_tag model, attribute, label
  find("##{attribute}-tags span.tag span", text: label).sibling('a').click
end

def add_tag model, attribute, label
  find("input##{model}_#{attribute}_tags_tag").send_keys(label)
  find('li.ui-menu-item .ui-menu-item-wrapper', text: label).click
end
