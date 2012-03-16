# To change this template, choose Tools | Templates
# and open the template in the editor.
Rhoconnect.configure do |config|
  config.app_endpoint = "http://wakinga.com"
  config.uri = "http://rhoservice42b7e79a.rhoconnect.com"
  config.authenticate = lambda { |credentials|
    User.authenticate(credentials['login'], credentials['password'])
  }
end
