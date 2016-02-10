ruby '2.2.4'
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>4.2.5'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Annotate ActiveRecord models with fields
gem 'annotate'

gem 'clockwork'
gem 'delayed_job_active_record'
gem 'rest-client'
gem 'nokogiri'

# Something Dokku uses
gem 'rails_12factor', group: :production

# Use bower assets
source 'https://rails-assets.org' do
  gem 'rails-assets-furtive' # Furtive - minimal CSS framework
end

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  #gem 'debugger' # TODO uncomment when it's not broken anymore

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
