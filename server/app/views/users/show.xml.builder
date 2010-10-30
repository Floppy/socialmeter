xml.instruct!
xml.users do |xml|
  @user.friends.each do |user|
    xml.user :name => user.name, :you => (user == @user) do
      xml.value user.current_value
      xml.carbon user.current_carbon
    end
  end
end