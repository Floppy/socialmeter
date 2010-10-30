require 'spec_helper'

describe Feed do
  before(:each) do
    @valid_attributes = {
      :current_value => 9.99,
      :unit => "value for unit",
      :current_carbon => 9.99,
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Feed.create!(@valid_attributes)
  end
end
