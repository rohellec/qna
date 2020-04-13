source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.4'
gem 'pg', '~> 1.1.4'
gem 'puma', '~> 4.3'
gem 'slim-rails', '~> 3.2'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 5.0'
gem 'uglifier', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.9'
gem 'decent_exposure', '~> 3.0'
gem 'devise', '~> 4.7.1'

gem 'bootsnap', '>= 1.4.5', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.9'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', '~> 4.1.2'
  gem 'rails-controller-testing', '~> 1.0.4'
end

group :development do
  gem 'web-console', '>= 3.7.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :test do
  gem 'capybara', '>= 3.29'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
