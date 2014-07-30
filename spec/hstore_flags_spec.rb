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

  it "shows available hstore flags" do
    expect(User::AVAILABLE_FLAGS).to eq [:fighter, :lover]
    expect(UserMultiFlags::AVAILABLE_MORE_FLAGS).to eq [:drinker, :smoker, :bartender]
    expect { User::AVAILABLE_MORE_FLAGS }.to raise_error
  end

  it "creates accessors for flags" do
    u = User.new(fighter: true)
    expect(u.fighter).to eq(true)
    expect(u.fighter?).to eq(true)
    expect(u.lover).to eq(false)
    expect(u.lover?).to eq(false)
    expect(u.not_fighter).to eq(false)
    expect(u.not_fighter?).to eq(false)
    expect(u.not_lover).to eq(true)
    expect(u.not_lover?).to eq(true)
  end

  it "creates scopes without scopes: false" do
    expect(User).to respond_to(:fighter)
    expect(User).to respond_to(:not_fighter)
    expect(User).to respond_to(:lover)
    expect(User).to respond_to(:not_lover)
  end

  it "does not create scopes with scopes: false" do
    expect(UserNoScopes).not_to respond_to(:fighter)
    expect(UserNoScopes).not_to respond_to(:not_fighter)
    expect(UserNoScopes).not_to respond_to(:lover)
    expect(UserNoScopes).not_to respond_to(:not_lover)
  end

  it "creates proper scopes when no field is defined" do
    expect(User.fighter.to_sql).to match(/defined\(users.flags, 'fighter'\) IS TRUE/)
    expect(User.not_fighter.to_sql).to match(/defined\(users.flags, 'fighter'\) IS NOT TRUE/)
  end

  it "creates proper scopes when field is defined" do
    expect(UserMultiFlags.drinker.to_sql).to match(/defined\(users.more_flags, 'drinker'\) IS TRUE/)
    expect(UserMultiFlags.not_drinker.to_sql).to match(/defined\(users.more_flags, 'drinker'\) IS NOT TRUE/)
  end

  it "updates changes with new bit values" do
    u = User.new
    expect(u.changes[:fighter]).to eq(nil)
    u.fighter = true
    expect(u.changes[:fighter]).to eq([false, true])
    u.fighter = false
    expect(u.changes[:fighter]).to eq([true, false]) # this is wrong, it should disappear
  end
end
