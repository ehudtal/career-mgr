require 'selenium/webdriver'

Capybara.register_driver :chrome_in_container do |app|
  Capybara::Selenium::Driver.new app, 
    browser: :remote, 
    url: 'http://chrome:4444/wd/hub', 
    desired_capabilities: :chrome
end

Capybara.register_driver :headless_chrome_in_container do |app|
  Capybara::Selenium::Driver.new app,
    browser: :remote,
    url: 'http://chrome:4444/wd/hub',
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {args: ['headless', 'disable-gpu']}
    )
end

Capybara.javascript_driver = :headless_chrome_in_container
Capybara.app_host = 'http://career-mgr:3010'