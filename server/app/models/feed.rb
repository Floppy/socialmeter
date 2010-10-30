class Feed < ActiveRecord::Base

  validates_numericality_of :current_value, :current_carbon
  validates_presence_of :unit, :energy_type

  belongs_to :user

end
