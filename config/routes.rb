Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users

  resources :users do
    resources :user_dates
    resources :meeting_dates
    resources :meetings
  end

  resources :user_dates do
    #resource :user
    #resource :meeting_date
  end

  resources :meeting_dates do
    resources :users
    resources :user_dates
    #resource :meeting
  end

  resources :meetings do
    resources :meeting_dates
    resources :user_dates
    resources :users
    collection do
      get "make", controller: "meeting_maker", action: "new", as: "make_new"
      post "make", controller: "meeting_maker", action: "create", as: "make"
      get "share/:id", controller: "meeting_maker", action: "show", as: "share"
      put "share/:id", controller: "meeting_maker", action: "add_date", as: "add_date"
      post "subscribe/:id", controller: "meeting_maker", action: "subscribe", as: "subscribe"
      delete "unsubscribe/:id", controller: "meeting_maker", action: "unsubscribe", as: "unsubscribe"
    end
  end

end
