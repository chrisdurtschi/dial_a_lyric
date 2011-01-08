source 'http://rubygems.org'

gem 'rails', '3.0.3'
gem 'rest-client'
gem 'nokogiri'
gem 'tropo-webapi-ruby'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'ruby-debug19'
end

group :test, :development do
  gem 'rspec-rails', '~>2.0.0'
end

group :test do
  gem 'autotest'
  gem 'webmock', '~> 1.6.1'
end

if RUBY_PLATFORM =~ /darwin/
  group :test do
    gem 'autotest-fsevent'
    gem 'autotest-growl'
  end
end


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
