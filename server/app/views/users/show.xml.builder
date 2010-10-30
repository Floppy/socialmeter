xml.instruct!
xml.users do |xml|
  xml.count @users.size
  @users.each_with_index do |user, i|
    xml.tag!("user_#{i}_name", user.name)
    xml.tag!("user_#{i}_is_you", (user == @user))
    xml.tag!("user_#{i}_value", user.current_value)
    xml.tag!("user_#{i}_carbon", user.current_carbon)
  end
end