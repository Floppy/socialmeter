# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def is_you?(user)
    @user == user
  end

end
