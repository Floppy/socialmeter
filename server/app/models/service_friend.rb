class ServiceFriend < ActiveRecord::Base
  belongs_to :service
  belongs_to :user

  validates_uniqueness_of :service_id, :scope => :user_id
  validates_uniqueness_of :user_id, :scope => :service_id

end
