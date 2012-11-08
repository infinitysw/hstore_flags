require 'hstore_flags/version'
require 'activerecord-postgres-hstore'
require 'activerecord-postgres-hstore/activerecord'

module HStoreFlags
  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE']

  def self.included(base)
    base.extend(ClassMethods)

    protected
    def set_hstore_flag_field(field, flag, value)
      new_val = TRUE_VALUES.include?(value)
      old_val = self.send(flag)
      return if new_val == old_val

      if defined? changed_attributes
        send(:changed_attributes).merge!(flag.to_s => old_val)
      end

      if new_val
        self[field] = (self[field] || {}).merge({flag.to_s => true.to_s})
      else
        destroy_key(field, flag)
      end

      new_val
    end
  end

  module ClassMethods
    def hstore_flags(*args)
      opts  = args.last.is_a?(Hash) ? args.pop.dup : {}
      field = "#{self.table_name}." + (opts[:field] || "flags")

      args.each do |flag|
        define_method("#{flag}")  {(self[field] || {})[flag.to_s] == "true"}
        define_method("#{flag}?") {(self[field] || {})[flag.to_s] == "true"}
        define_method("#{flag}=") {|val| set_hstore_flag_field(field, flag, val)}

        unless opts[:scopes] == false
          scope "#{flag}",     where("defined(#{field}, '#{flag}') IS TRUE")
          scope "not_#{flag}", where("defined(#{field}, '#{flag}') IS NOT TRUE")

          class_eval <<-EVAL
            def self.#{flag}_condition
              "(defined(#{field}, '#{flag}') IS TRUE)"
            end

            def self.not_#{flag}_condition
              "(defined(#{field}, '#{flag}') IS NOT TRUE)"
            end
          EVAL
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, HStoreFlags)
