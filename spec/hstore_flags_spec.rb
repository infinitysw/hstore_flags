require 'spec_helper'

class User < ActiveRecord::Base
  hstore_flags :fighter, :lover
end

class UserNoScopes < ActiveRecord::Base
  self.table_name = "users"
  hstore_flags :fighter, :lover, :referee, scopes: false
end

class UserMultiFlags < ActiveRecord::Base
  self.table_name = "users"
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
    User.should respond_to(:fighter)
    User.should respond_to(:not_fighter)
    User.should respond_to(:lover)
    User.should respond_to(:not_lover)
  end

  it "does not create scopes with scopes: false" do
    UserNoScopes.should_not respond_to(:fighter)
    UserNoScopes.should_not respond_to(:not_fighter)
    UserNoScopes.should_not respond_to(:lover)
    UserNoScopes.should_not respond_to(:not_lover)
  end

  it "creates proper scopes when no field is defined" do
    User.fighter.to_sql.should =~ /defined\(flags, 'fighter'\) IS TRUE/
    User.not_fighter.to_sql.should =~ /defined\(flags, 'fighter'\) IS NOT TRUE/
  end

  it "creates proper scopes when field is defined" do
    UserMultiFlags.drinker.to_sql.should =~ /defined\(more_flags, 'drinker'\) IS TRUE/
    UserMultiFlags.not_drinker.to_sql.should =~ /defined\(more_flags, 'drinker'\) IS NOT TRUE/
  end
end
