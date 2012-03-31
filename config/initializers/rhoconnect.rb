Rhoconnect.configure do |config|
  #config.app_endpoint = "http://wakinga-dev.heroku.com"
  config.token = "1d2006ac42c46c885227d1525d074131909eefb2caf8a897c3ecd391c6770b5767d8f4e673f1cb132a62b2ce01edf3cf53b12bd3e8dc296c7499fcb22eca95ba"
  #config.uri = "http://ec2-23-20-216-61.compute-1.amazonaws.com:9292"
  config.authenticate = lambda { |credentials|
    User.authenticate(credentials['login'], credentials['password'])
  }
end