defmodule StorexWeb.Router do
  use StorexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug StorexWeb.Plugs.Cart
    plug StorexWeb.Plugs.ItemsCount
    plug StorexWeb.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StorexWeb do
    pipe_through :browser # Use the default browser stack

    get "/", BookController, :index
    get "/books", BookController, :index
    get "/books/:id", BookController, :show

    resources "/carts",     CartController,     only: [:show, :create, :delete], singleton: true
    resources "/users",     UserController,     only: [:new, :create]
    resources "/sessions",  SessionController,  only: [:new, :create], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", StorexWeb do
  #   pipe_through :api
  # end
end
