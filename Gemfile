source 'https://rubygems.org'

gem 'pg'
gem 'mysql2'
gem 'activerecord'
gem 'mini_record'

# app
gem 'cuba'
gem 'rack-protection'
gem 'haml'
gem 'coffee-script'
gem 'mimemagic'
gem 'sass'
gem 'tilt', '>= 2.0'
gem 'mab'
gem 'cuba-sugar', github: 'cj/cuba-sugar'
gem 'shield', github: 'cyx/shield'

# server
gem 'shotgun'
gem 'puma'
gem 'thin'
gem 'unicorn'

group :development do
  gem 'rack-livereload'
  gem 'guard-livereload', require: false
  gem 'rugged'
end

group :development, :test do
  gem 'pry'
  gem 'awesome_print'
  gem 'mr-sparkle', github: 'cj/mr-sparkle'
  gem 'commander', github: 'visionmedia/commander'
end

group :test do
  gem 'rspec', '3.0.0.beta2'
  gem 'rack-test'
  gem 'capybara'
  gem 'cutest'
end
