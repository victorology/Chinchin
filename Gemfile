source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.8'
gem 'bootstrap-sass', '2.0.0'
gem 'omniauth-facebook'
gem 'omniauth-facebook-access-token'
gem 'fb_graph'
gem 'newrelic_rpm'
gem 'activeadmin', '0.6.0'
gem 'formtastic', '~> 2.1.1' # Added for ActiveAdmin
gem "meta_search", '>= 1.1.0.pre' # Added for ActiveAdmin
gem 'resque', "~> 1.22.0"
gem 'thin'
gem 'delayed_job_active_record'
gem 'factory_girl_rails' # Added for rspec test for models
gem 'asset_sync' # Added for Heroku and Amazon S3 assets
gem 'memcachier' # Added for Caching
gem 'dalli' # Added for Caching
gem 'unicorn' # new web server
gem 'urbanairship' # Added for push notification
gem 'pg', '0.12.2' # Added for postgresql management
gem 'rails_12factor' # Added for skipping plugin injection
gem 'rspec-rails', '~> 2.12.0'
gem 'rabl'
gem 'oj'
gem 'zodiac'
gem 'mandrill-api'
gem 'kaminari'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
	gem 'sqlite3', '1.3.5'
  gem 'debugger', '~> 1.5.0'
  gem 'spork', '~> 0.9.0.rc'
  gem 'simplecov', :require => false
  gem 'lol_dba'
end

group :development do
	gem 'annotate', '2.5.0'
	gem 'better_errors'
	gem 'binding_of_caller' # Added to support better errors
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.4'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.3'
end

gem 'jquery-rails', '2.0.2'

group :test do
	gem 'capybara', '1.1.2'
  gem 'vcr'
  gem 'webmock'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
