require 'rubygems'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 10 # seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 15)

# navigate to create account page
driver.get "http://localhost:3000/"
driver.find_element(:id, "create_account").click

# fill out form
name = driver.find_element(:id, "user_name")
name.send_keys "test"
puts "Passed: Name field exists" if name.displayed?

driver.find_element(:id, "user_email").send_keys "test@foo.bar"
driver.find_element(:id, "user_password").send_keys "arcade"
driver.find_element(:id, "user_password_confirmation").send_keys "arcade"
driver.find_element(:name, "commit").click

driver.manage.window.maximize

#driver.quit
