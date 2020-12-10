source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.1.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'
# gem 'therubyracer', platforms: :ruby
# gem 'jquery-rails'
gem 'bcrypt'
gem 'bootsnap', '>= 1.4.4'

group :development, :test do
  gem 'byebug', platform: :mri
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rubocop', '~> 0.49', require: false
end

gem 'simplecov', require: false, group: :test

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# gem 'bootstrap-sass', '~> 3.3.6'
gem 'redcarpet'
gem 'coderay'
gem 'kaminari'
gem 'bugsnag'
