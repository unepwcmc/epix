source 'https://rubygems.org'
# Frameworks
gem 'rails', '~> 5.0.0'

# DB
gem 'pg', '~> 0.18.4'

# Frontend
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'font-awesome-rails'

# Configuration
gem 'dotenv-rails', '~> 2.1.1'

# Logging'n'tracking
gem 'appsignal', '~> 1.1.9'

gem 'devise'

gem 'savon'
gem 'wash_out'

gem 'attr_encrypted', '~>3.0.0'
gem 'cancancan', '~> 1.10'
gem 'nokogiri'
gem 'whenever', require: false
gem 'httparty'

gem 'select2-rails'

# GA Tracking
gem 'staccato-rails'

gem 'capistrano-git-submodule-strategy', '~> 0.1', :github => 'ekho/capistrano-git-submodule-strategy'

group :development do
  # Docs
  gem 'yard', '~> 0.8.7.6'
  gem 'redcarpet', '~> 3.3.4'

  # Deployment
  gem 'capistrano-rails'
  gem 'capistrano', '~> 3.4', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm',   '~> 0.1', require: false
  gem 'capistrano-passenger', '~> 0.2.0', require: false

  # Mailer
  gem 'letter_opener'


end

# Debugging
gem 'web-console', '~> 2.0', group: :development

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.4'
end

group :test do
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end
