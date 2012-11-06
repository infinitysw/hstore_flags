HStore Flags
------------

integer/bit flags aggrevating you? try this.

Requirements
------------

* Postgresql 8.4+ with contrib and rails 3
* Read [activerecord-postgres-hstore](https://raw.github.com/engageis/activerecord-postgres-hstore) for index creation

Installation
------------

TODO

Usage
-----

```ruby
# defining flags
class User < ActiveRecord::Base
  hstore_flags :active, :admin
  hstore_flags :customer, :vendor, :drop_ship, field: "user_type"
end

class Group < ActiveRecord::Base
  hstore_flags :active, :public, invite_only, scopes: false
end

# setting flags
u = User.new
u.active = true
u.vendor = false

# automatic scope creation
User.active.to_sql        #=> SELECT * FROM users WHERE (defined(flags, 'active') IS TRUE)
User.not_drop_ship.to_sql #=> SELECT * FROM users WHERE (defined(user_type, 'drop_ship') IS NOT TRUE)
```

* `field` option defaults to `flags`
* `scopes: false` disables scope creation. though im not sure how useful that is
