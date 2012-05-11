require 'spec_helper'

describe ServiceFriend do
  before(:each) do
    @valid_attributes = {
      :service_id => 1,
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ServiceFriend.create!(@valid_attributes)
  end
end
