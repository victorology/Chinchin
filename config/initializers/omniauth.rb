# This is the configuration for OmniAuth
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '352455024800701', '035385fe9e7db60eba187ab83fb27cb6',
  scope: 'user_about_me,user_birthday,user_education_history,user_hometown,user_location,user_photos,user_relationships,user_work_history,friends_about_me,friends_birthday,friends_education_history,friends_hometown,friends_location,friends_photos,friends_relationships,friends_work_history,email,read_stream,publish_stream',
  display: 'popup'
end