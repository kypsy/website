class AdminAuthenticator
  def self.matches?(request)
    user = User.find_by(auth_token: request.cookie_jar.signed[:auth_token]) unless request.cookie_jar[:auth_token].blank?
    user && user.admin?
  end
end

Rails.application.routes.draw do
  # No WWW
  constraints(subdomain: "www") do
    get '(*any)' => redirect { |params, request|
      URI.parse(request.url).tap { |uri| uri.host.sub!(/^www\./i, '') }.to_s
    }
  end

  namespace :api do
    resources :lat_lngs, only: :index
    resources :users, only: [:index, :show]
  end

  # Admin
  namespace :admin do
    get    "/" => "dashboard#index",                as: :dashboard
    get    "/@:username/edit", to: "users#edit",    as: :edit_user,   username: /[^\/]+/
    patch  "/@:username",      to: "users#update",  as: :update_user, username: /[^\/]+/
    delete "/@:username",      to: "users#destroy", as: :user,        username: /[^\/]+/

    resources :photos, only: [:show, :destroy]
    resources :red_flags, path: "red-flags"
  end

  # Static-y pages
  root to: "welcome#index"
  get "/terms",      to: "about#terms",    as: :terms
  get "/privacy",    to: "about#privacy",  as: :privacy
  get "/about",      to: "about#us",       as: :about
  get "/goodbye",    to: "about#goodbye",  as: :goodbye
  get "/page/:page", to: "welcome#index"

  # Auth
  get "/signout",                 to: "sessions#destroy", as: :signout
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure",            to: "sessions#failure"

  # People objects
  resources :photos,              except: [:index, :show]
  resources :conversations,       only:   [:index]

  #  Incoming Email
  get  "/photos/email",           to: "photos#email"
  post "/photos/email",           to: "photos#email"

  # People pages
  get    "/oops",                  to: redirect("/start")
  patch  "/oops",                  to: 'users#create',  as: :user_create
  get    "/start",                 to: "users#new",     as: :start
  get    "/settings",              to: "users#edit",    as: :settings
  patch  "/settings",              to: "users#update",  as: :update_settings
  get    "/people/(page/:page)",   to: "users#index",   as: :people
  get    "/@:username",            to: "users#show",    as: :person, username: /[^\/]+/
  get    "/@:username",            to: "users#show",    as: :user,   username: /[^\/]+/
  delete "/@:username",            to: "users#destroy", username: /[^\/]+/

  # Action paths
  post   "/@:username/crush(.:format)",      to: "crushes#create",        as: :crush,               username: /[^\/]+/
  delete "/@:username/uncrush(.:format)",    to: "crushes#destroy",       as: :uncrush,             username: /[^\/]+/
  post   "/@:username/block(.:format)",      to: "blocks#create",         as: :action_block,        username: /[^\/]+/
  delete "/@:username/unblock(.:format)",    to: "blocks#destroy",        as: :action_unblock,      username: /[^\/]+/
  post   "/@:username/bookmark(.:format)",   to: "bookmarks#create",      as: :action_bookmark,     username: /[^\/]+/
  delete "/@:username/unbookmark(.:format)", to: "bookmarks#destroy",     as: :action_unbookmark,   username: /[^\/]+/
  get    "/@:username/message",              to: "messages#new",          as: :new_message,         username: /[^\/]+/
  post   "/@:username/message(.:format)",    to: "messages#create",       as: :messages,            username: /[^\/]+/
  get    "/@:username/conversation",         to: "conversations#show",    as: :conversation,        username: /[^\/]+/
  delete "/@:username/conversation",         to: "conversations#destroy", as: :delete_conversation, username: /[^\/]+/
  post   "/red-flags/:id",                   to: "red_flags#create",      as: :flag
  delete "/red-flags/:id",                   to: "red_flags#destroy"

  # filters
  get "/diets",                     to: "searches#index",  as: :diets            , column: "diets"
  get "/straightedgeness",          to: "searches#index",  as: :straightedgeness , column: "straightedgeness"
  get "/straightedgeness",          to: "searches#index",  as: :label            , column: "straightedgeness"
  get "/searches",                  to: "searches#index"
  get "/search/*search/page/:page", to: "users#index"
  get "/search/*search",            to: "users#index",   as: :search

  # Last ditch effort to catch mistyped @username paths
  get "/:username", to: redirect { |params, request| "/@#{params[:username]}"}
end
