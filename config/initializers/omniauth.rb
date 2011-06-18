Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'R8FAVGQiGBnItWtrMMvvw', '1ioDqnX6LxgTz5RGHzdjE74X6L3ADcqFLgatnAwv7E4'
  provider :facebook, '210400255664247', '4db5afe3862e69e5ba2ff6ba235c7c83'
end