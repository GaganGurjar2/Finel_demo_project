Rails.application.routes.draw do
 resources :users
 match "*path", to: "application#render_404", via: :all

end
