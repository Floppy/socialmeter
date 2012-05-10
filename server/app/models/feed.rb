class Feed < ActiveRecord::Base

  #has_amee_profile

  validates_numericality_of :current_value, :current_carbon, :average_value, :average_carbon
  validates_presence_of :energy_type

  belongs_to :user

end
