require 'rubygems'
if ENV['VERSION']
  gem 'activesupport', ENV['VERSION']
  gem 'activerecord',  ENV['VERSION']
end
$LOAD_PATH << 'lib'
require 'hstore_flags'
require 'timeout'

require 'active_record'
puts "Using ActiveRecord #{ActiveRecord::VERSION::STRING}"

require File.expand_path('../database', __FILE__)
