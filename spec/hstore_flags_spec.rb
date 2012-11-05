require 'spec_helper'

class User < ActiveRecord::Base
  hstore_flags :fighter, :lover
end

class UserNoScopes < ActiveRecord::Base
  self.table_name = "users"
  hstore_flags :fighter, :lover, :referee, scopes: false
end

class UserMultiFlags < ActiveRecord::Base
  hstore_flags :fighter, :lover, :referee
  hstore_flags :drinker, :smoker, :bartender, field: "more_flags"
end

describe HStoreFlags do
  it "creates accessors for flags" do
    u = User.new(fighter: true)
    u.fighter.should  == true
    u.fighter?.should == true
    u.lover.should    == false
    u.lover?.should   == false
  end

  it "creates scopes without scopes: false" do
    u = User.new(fighter: true)
    u.save
    User.fighter.count.should == 1
    User.not_figher.count.should == 0
    User.not_lover.count.should == 1
    User.lover.count.should == 0
  end

  it "does not create scopes with scopes: false" do
  end

end
