module FeatureHelper
  def login user_type=:admin
    create :"#{user_type}_user", email: 'admin@beyondz.org' unless User.find_by(email: 'admin@beyondz.org')
    visit root_path
    
    logged_in = '#menu-icon'
  
    begin
      find(logged_in, wait: 5)
    rescue Capybara::ElementNotFound
      find("img[alt='Braven']").click

      begin
        find(logged_in, wait: 5)
      rescue
        begin
          expect(page).to have_content('PLATFORM LOGIN')
    
          fill_in 'username', with: Rails.application.secrets.test_sso_username
          fill_in 'password', with: Rails.application.secrets.test_sso_password

          click_on 'Log in'
        rescue
        end
      end
    end
  end

  def remove_tag model, attribute, label
    attribute_label = attribute.to_s.gsub('_', '-')
    find("##{attribute_label}-tags span.tag span", text: label).sibling('a').click
  end

  def add_tag model, attribute, label
    find("input##{model}_#{attribute}_tags_tag").send_keys(label)
    find('li.ui-menu-item .ui-menu-item-wrapper', text: label).click
    
    expect_tag model, attribute, label
  end
  
  def expect_tag model, attribute, label
    attribute_label = attribute.to_s.gsub('_', '-')
    expect(page).to have_css("##{attribute_label}-tags span.tag span", text: label)
  end

  def visit_page label
    expect(page).to have_content(label.to_s.titleize)
    click_on label.to_s.titleize
  end

  def expect_list_link_for label, options={}
    titleized = label.to_s.titleize
    options[:link]  ||= "full #{titleized.downcase} list"
    options[:title] ||= titleized
    options[:within] ||= 'html'
  
    new_tab = window_opened_by do
      within(options[:within]) do
        click_on options[:link]
      end
    end
    
    within_window new_tab do
      expect(page).to have_content(options[:title])
    end
  end
end