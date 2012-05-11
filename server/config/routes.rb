SocialMeter::Application.routes.draw do

  resources :users do
    resources :feeds
    resources :services
  end

end
