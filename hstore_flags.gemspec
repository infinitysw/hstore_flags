$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
name = "hstore_flags"
require "#{name}/version"

Gem::Specification.new name, HStoreFlags::VERSION do |s|
  s.summary  = "Store many boolean flags in an hstore column in PostgreSQL"
  s.authors  = ["Zachery Hostens"]
  s.email    = "zachery.hostens@countrystone.com"
  s.homepage = "http://github.com/infinitysw/hstore_flags"
  s.files    = `git ls-files`.split("\n")
  s.license  = "MIT"
end
