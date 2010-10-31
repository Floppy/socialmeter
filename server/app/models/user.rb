class User < ActiveRecord::Base

  extend ActiveSupport::Memoizable

  validates_presence_of :name

  has_many :feeds
  has_many :services

  def friends(service = nil)
    list = []
    if service
      list = services.find(:first, :conditions => {:name => service}).friends rescue []
      list << self
    else
      list = User.find(:all)
    end
    list.sort{|a,b| a.current_value <=> b.current_value}
  end

  def current_carbon
    feeds.inject(0.0){|total, x| total += x.current_carbon}
  end
  memoize :current_carbon

  def current_value
    feeds.inject(0.0){|total, x| total += x.current_value}
  end
  memoize :current_value

  def human_name
    name.titleize
  end
  memoize :human_name

end
