class User < ActiveRecord::Base

  validates_presence_of :name

  has_many :feeds

  def friends
    User.find(:all)
  end

  def current_carbon
    feeds.inject(0.0){|total, x| total += x.current_carbon}
  end

  def current_value
    feeds.inject(0.0){|total, x| total += x.current_value}
  end

end
