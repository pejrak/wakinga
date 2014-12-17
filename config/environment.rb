# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mindbase::Application.initialize! do |config|

end

require "will_paginate/array"
