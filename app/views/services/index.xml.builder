xml.instruct!
xml.user do
  @user.services.each do |service|
    xml.service service.name
  end
end