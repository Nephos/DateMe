Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users
  resources :comments

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
      get "shared", controller: "meeting_maker", action: "index", as: "shared"
      get "make", controller: "meeting_maker", action: "new", as: "make_new"
      post "make", controller: "meeting_maker", action: "create", as: "make"
    end
  end

  scope "meetings" do
    scope ":meeting_uuid" do
      get "share", controller: "meeting_maker", action: "show", as: "meeting_share"
      post "share", controller: "meeting_maker", action: "update", as: "meeting_update"
      post "subscribe", controller: "subscription_maker", action: "create", as: "meeting_subscribe"
      delete "unsubscribe", controller: "subscription_maker", action: "destroy", as: "meeting_unsubscribe"
      # TODO: maybe using PUT is not very standard. Using a POST seems to be a more cool stuff
      put "date", controller: "date_maker", action: "create", as: "meeting_add_date"
    end
    delete "date/:meeting_date_id", controller: "date_maker", action: "destroy", as: "meeting_rm_date"
  end

  scope "votes" do
    post "", controller: "vote_maker", action: "create"
    get ":user_date_id", controller: "vote_maker", action: "show", as: "get"
    patch ":user_date_id", controller: "vote_maker", action: "update", as: "set"
  end

end
