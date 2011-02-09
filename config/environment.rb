# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mindbase::Application.initialize! do |config|

# add dependency on Devise authentication model
# config.gem 'warden'
# config.gem 'devise'

  config.gem 'nokogiri'
end