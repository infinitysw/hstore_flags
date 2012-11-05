require 'active_record'

# connect
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'testing')

ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS hstore")

ActiveRecord::Schema.define(version: 1) do
  execute "DROP TABLE IF EXISTS users"

  create_table :users do |t|
    t.column :flags, :hstore
    t.column :more_flags, :hstore
  end
end
