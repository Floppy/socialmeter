SERVICE_LIST = ["Twitter"]

class Service < ActiveRecord::Base

  validates_inclusion_of :name, :in=>SERVICE_LIST
  validates_uniqueness_of :name, :scope => :user_id
  validates_uniqueness_of :external_id, :scope => :name

  before_save :update_avatar
  after_save :update_friends

  def self.service_list
    SERVICE_LIST
  end

  belongs_to :user
  has_many :service_friends
  has_many :friends, :through => :service_friends, :source => :user

  def update_friends
    send "update_#{name.downcase}_friends"
  end

  def update_avatar
    send "update_#{name.downcase}_friends"
  end

  def update_twitter_friends

  end

  def update_twitter_avatar

  end

end
