Rails.application.routes.draw do
  root to: "meetings#index"
  devise_for :users

  resources :user_dates
  resources :users
  resources :meeting_dates
  resources :meetings do
    collection do
      get "make", controller: "meeting_maker", action: "new", as: "make_new"
      post "make", controller: "meeting_maker", action: "create", as: "make"
      get "share", controller: "meeting_maker", action: "show", as: "share"
    end
  end

end
