defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ApiWeb.ApiAuthPlug, otp_app: :api
  end

  pipeline :auth_check do
    plug ApiWeb.RequireAuthenticated, error_handler: ApiWeb.ApiAuthErrorHandler
  end

  scope "/api", ApiWeb do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create]
  end

  scope "/api", ApiWeb do
    pipe_through [:api, :auth]
    # resources "/products", ProductController, only: [:show, :index]
  end
  
  scope "/api", ApiWeb do
    pipe_through [:auth, :auth_check]
    
    resources "/", HomeController, only: [:index]
  end
end
