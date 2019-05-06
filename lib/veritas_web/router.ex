defmodule VeritasWeb.Router do
  use VeritasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VeritasWeb do
    pipe_through :browser

    get "/keys", PageController, :keys
    get "/about", PageController, :about
    get "/conversation/:script/:text", PageController, :conversation
    get "/history", PageController, :history
    get "/conversation", PageController, :conversation
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", VeritasWeb do
  #   pipe_through :api
  # end
end
