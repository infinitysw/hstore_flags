require 'rubygems'
if ENV['VERSION']
  gem 'activesupport', ENV['VERSION']
  gem 'activerecord',  ENV['VERSION']
end

$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'active_record'
require 'hstore_flags'

puts "Using ActiveRecord #{ActiveRecord::VERSION::STRING}"

require File.expand_path('../database', __FILE__)
