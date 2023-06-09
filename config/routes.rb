Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "weather/fetch_places"
  post "weather/fetch_forecast"

  post "alerts_manager/send_alert"
end
