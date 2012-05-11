class User < ActiveRecord::Base

  extend ActiveSupport::Memoizable

  attr_accessible :name

  validates_presence_of :name

  has_many :feeds
  has_many :services

  def friends(service = nil)
    list = []
    if service
      list = services.where(:name => service).first.friends.clone rescue []
      list << self
    else
      list = User.all
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

  def average_carbon
    feeds.inject(0.0){|total, x| total += x.average_carbon}
  end
  memoize :average_carbon

  def average_value
    feeds.inject(0.0){|total, x| total += x.average_value}
  end
  memoize :average_value

  def human_name
    name.titleize
  end
  memoize :human_name

  def profile_image_url(service)
    conditions = {}
    conditions[:name] = service if service
    services.where(conditions).first.profile_image_url rescue ''
  end

  def service_link(service)
    conditions = {}
    conditions[:name] = service if service
    services.where(conditions).first.link rescue ''
  end

end
