require 'active_record'

# connect
ActiveRecord::Base.establish_connection(adapter: 'pg', database: 'testing')

ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.hstore :flags
    t.hstore :more_flags
  end
end
