def login user_type=:admin
  create :"#{user_type}_user", email: 'admin@beyondz.org' unless User.find_by(email: 'admin@beyondz.org')
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

def visit_page label
  expect(page).to have_content(label.to_s.titleize)
  click_on label.to_s.titleize
end

def expect_list_link_for label, options={}
  titleized = label.to_s.titleize
  options[:link]  ||= "full #{titleized.downcase} list"
  options[:title] ||= titleized
  
  new_tab = window_opened_by{ click_on options[:link] }
  within_window new_tab do
    expect(page).to have_content(options[:title])
  end
end