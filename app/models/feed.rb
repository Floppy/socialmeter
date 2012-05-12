require 'net/http'

class Feed < ActiveRecord::Base

  #has_amee_profile

  validates_numericality_of :current_value, :current_carbon, :average_value, :average_carbon
  validates_presence_of :energy_type

  belongs_to :user

  attr_accessible :external_id, :energy_type, :current_value, :current_carbon

  after_create :create_cosm_trigger
  
  def create_cosm_trigger
    # Prepare post data
    env, stream = external_id.split(':')
    post_data = {
      :url =>  "http://socialmeter.floppy.org.uk/users/#{user.id}/feeds/#{id}/cosm_trigger",
      :trigger_type => "change",
      :environment_id => env,
      :stream_id => stream
    }
    # Do post
    uri = URI('http://api.cosm.com/v2/triggers/')
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Post.new uri.request_uri
      request['X-ApiKey'] = COSM_API_KEY
      request.body = post_data.to_json
      http.request request
    end
  end

end
