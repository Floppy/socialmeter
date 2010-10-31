xml.instruct!
xml.users do |xml|
  xml.count @users.size
  @users.each_with_index do |user, i|
    xml.tag!("user_#{i}_name", user.name)
    xml.tag!("user_#{i}_is_you", is_you?(user))
    xml.tag!("user_#{i}_value", user.current_value)
    xml.tag!("user_#{i}_carbon", user.current_carbon)
    xml.tag!("user_#{i}_average_value", user.average_value)
    xml.tag!("user_#{i}_average_carbon", user.average_carbon)
    xml.tag!("user_#{i}_image_url", user.profile_image_url(params[:service]))
  end
end