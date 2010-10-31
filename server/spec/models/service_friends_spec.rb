require 'spec_helper'

describe ServiceFriends do
  before(:each) do
    @valid_attributes = {
      :service_id => 1,
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ServiceFriends.create!(@valid_attributes)
  end
end
