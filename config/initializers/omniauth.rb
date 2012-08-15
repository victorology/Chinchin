# This is the configuration for OmniAuth
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '352455024800701', '035385fe9e7db60eba187ab83fb27cb6'
end