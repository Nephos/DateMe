Rails.application.routes.draw do
  root to: "meetings#index"
  devise_for :users

  resources :user_dates
  resources :users
  resources :meeting_dates
  resources :meetings
end
