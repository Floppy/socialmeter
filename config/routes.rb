SocialMeter::Application.routes.draw do

  resources :users do
    resources :feeds do
      post 'cosm_trigger', :on => :member
    end
    resources :services
  end

end
