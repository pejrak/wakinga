Rhoconnect.configure do |config|
  config.app_endpoint = "http://wakinga-dev.heroku.com"
  config.uri = "http://wakinga-connect.heroku.com"
  config.authenticate = lambda { |credentials|
    User.authenticate(credentials['login'], credentials['password'])
  }
end