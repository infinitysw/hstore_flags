require 'hstore_flags/version'
require 'active_support'
require 'active_support/version'
require 'activerecord-postgres-hstore'

module HStoreFlags
  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE']

  def self.included(base)
    base.extend(ClassMethods)

    protected
    def set_hstore_flag_field(field, flag, value)
      if TRUE_VALUES.include?(value)
        self[field] = (self[field] || {}).merge({flag => true})
      else
        self.destroy_keys(field, flag)
      end
    end
  end

  module ClassMethods
    def hstore_flags(*args)
      opts  = args.last.is_a?(Hash) ? args.pop.dup : {}
      field = opts[:field] || "flags"

      args.each do |flag|
        define_method("#{flag}")  {(self[field] || {})[flag.to_s] == "true"}
        define_method("#{flag}?") {(self[field] || {})[flag.to_s] == "true"}
        define_method("#{flag}=") {|val| set_hstore_flag_field(field, flag, val)}

        unless opts[:scopes] == false
          scope "#{flag}",     where("defined(#{field}, '#{flag}') IS TRUE")
          scope "not_#{flag}", where("defined(#{field}, '#{flag}') IS NOT TRUE")
        end
      end
    end
  end
end
