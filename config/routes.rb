Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  root "pages#landing"

  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get "join/:invite_code", to: "clubs#join_by_code", as: :join_by_code
  resources :sessions, only: [ :destroy ]
  resource  :password, only: [ :edit, :update ]
  namespace :identity do
    resource :email,              only: [ :edit, :update ]
    resource :email_verification, only: [ :show, :create ]
    resource :password_reset,     only: [ :new, :edit, :create, :update ]
  end
  namespace :authentications do
    resources :events, only: :index
  end
  get  "/auth/failure",            to: "sessions/omniauth#failure"
  get  "/auth/:provider/callback", to: "sessions/omniauth#create"
  post "/auth/:provider/callback", to: "sessions/omniauth#create"
  post "users/:user_id/masquerade", to: "masquerades#create", as: :user_masquerade
  post "accept_invitation/:club_id", to: "members#accept", as: :accept_invitation
  delete "deny_invitation/:club_id", to: "members#deny", as: :deny_invitation
  get "unsubscribe/:token", to: "members#unsubscribe", as: :unsubscribe_club
  delete "unsubscribe/:token", to: "members#process_unsubscribe", as: :process_unsubscribe

  resources :clubs do
    get "random_question", on: :member
    resources :members do
      member do
        patch :change_role
        post :resend_invitation
      end
    end
    resources :issues do
      resources :issue_questions
      resources :answers do
        resources :comments, only: [ :create ]
      end
      post "deliver", to: "issues#deliver", as: :deliver
      post "reply", to: "answers#create", as: :reply
      get "reply", to: "answers#new", as: :new_reply
      get "reply/edit", to: "answers#edit", as: :edit_reply
    end
    resources :questions
  end

  get "impersonate/:user_id", to: "impersonations#create", as: :impersonate

  # resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  resources :updates, only: [ :index, :show ]
end
