SERVICE_LIST = ["Twitter"]

class Service < ActiveRecord::Base

  validates_inclusion_of :name, :in=>SERVICE_LIST
  validates_uniqueness_of :name, :scope => :user_id
  validates_uniqueness_of :external_id, :scope => :name

  def self.service_list
    SERVICE_LIST
  end

  belongs_to :user
  has_many :service_friends
  has_many :friends, :through => :service_friends, :source => :user

end
