Rhoconnect.configure do |config|
  config.app_endpoint = "wakinga-dev.heroku.com"
  config.uri = "http://wakinga-connect.heroku.com:9292"
  config.authenticate = lambda { |credentials|
    User.authenticate(credentials['login'], credentials['password'])
  }
end