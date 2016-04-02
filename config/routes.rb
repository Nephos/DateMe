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

    get "share", controller: "meeting_maker", action: "show", as: "share"
    # TODO: maybe using PUT is not very standard. Using a POST seems to be a more cool stuff
    put "share", controller: "date_maker", action: "create", as: "add_date"

    post "subscribe", controller: "subscription_maker", action: "create", as: "subscribe"
    delete "unsubscribe", controller: "subscription_maker", action: "destroy", as: "unsubscribe"

    collection do
      get "make", controller: "meeting_maker", action: "new", as: "make_new"
      post "make", controller: "meeting_maker", action: "create", as: "make"
    end

  end

end
