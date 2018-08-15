require 'selenium/webdriver'
require 'warden'

include Warden::Test::Helpers

# TODO: when not runing in docker, configure the Selenium Driver to use however the headless browser is setup on the Admin Server or local machine
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

Capybara.javascript_driver = :chrome_in_container
Capybara.app_host = 'http://career-spec:3011'
