xml.instruct!
xml.users :count => @users.size do |xml|
  xml.totals do
    xml.value @total_value
    xml.carbon @total_carbon
    xml.average_value @total_average_value
    xml.average_carbon @total_average_carbon
  end
  @users.each_with_index do |user, i|
    xml.user :position => i+1 do
      xml.name user.name
      xml.is_you is_you?(user)
      xml.value user.current_value
      xml.carbon user.current_carbon
      xml.average_value user.average_value
      xml.average_carbon user.average_carbon
      xml.image user.profile_image_url(params[:service])
    end
  end
end