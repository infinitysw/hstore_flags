$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "hstore_flags/version"

Gem::Specification.new do |s|
  s.name          = "hstore_flags"
  s.version       = HStoreFlags::VERSION
  s.summary       = "Store many boolean flags in an hstore column in PostgreSQL"
  s.authors       = ["Zachery Hostens"]
  s.email         = "zachery.hostens@countrystone.com"
  s.homepage      = "https://github.com/infinitysw/hstore_flags"
  s.files         = `git ls-files`.split("\n")
  s.license       = "MIT"
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", "~> 4.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "pg"
end
