SERVICE_LIST = ["Twitter"]

class Service < ActiveRecord::Base

  validates_inclusion_of :service_name, :in=>SERVICE_LIST

  def self.service_list
    SERVICE_LIST
  end

  has_many :service_friends
  has_many :friends, :through => :service_friends, :source => :user

end
