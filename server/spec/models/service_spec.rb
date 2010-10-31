require 'spec_helper'

describe Service do
  before(:each) do
    @valid_attributes = {
      :service_type => "value for service_type",
      :external_id => "value for external_id"
    }
  end

  it "should create a new instance given valid attributes" do
    Service.create!(@valid_attributes)
  end
end
