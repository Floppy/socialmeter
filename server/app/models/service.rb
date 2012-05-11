require 'net/http'
require 'uri'

SERVICE_LIST = ["Twitter"]

class Service < ActiveRecord::Base

  validates_inclusion_of :name, :in=>SERVICE_LIST
  validates_uniqueness_of :name, :scope => :user_id
  validates_uniqueness_of :external_id, :scope => :name

  before_save :get_avatar
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

  def get_avatar
    send "get_#{name.downcase}_avatar"
  end

  def link
    case name
    when 'Twitter'
      "https://twitter.com/#{external_id}"
    else
      ''
    end
  end

  def update_twitter_friends
    # Probably could be done through Twitter gem, but it's 3am and it's not working so
    # bollocks to it. This will only get the first 100, but that'll do for now.
    result = Net::HTTP.get URI.parse("http://api.twitter.com/1/statuses/friends.xml?screen_name=#{external_id}")
    doc = Nokogiri::XML(result)
    doc.xpath('/users/user/screen_name/text()').each do |x|
      s = Service.where(:name => 'Twitter', :external_id => x.to_s).first
      friends << s.user if s && !friends.include?(s.user)
    end
  end

  def get_twitter_avatar
    u = Twitter.user(external_id)
    write_attribute(:profile_image_url, u.profile_image_url)
  end

end
