# To change this template, choose Tools | Templates
# and open the template in the editor.
Rhoconnect.configure do |config|
  config.authenticate = lambda { |credentials|
    User.authenticate(credentials['login'], credentials['password'])
  }
end