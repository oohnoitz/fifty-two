defmodule FiftyTwo.Router do
  use FiftyTwo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug FiftyTwo.Plug.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", FiftyTwo do
    pipe_through [:browser, :session]

    get "/", PageController, :index

    get  "/login",  AuthController, :new
    post "/login",  AuthController, :create
    get  "/logout", AuthController, :delete

    resources "/challenges", ChallengeController
    resources "/games", GameController
    resources "/users", UserController
  end

  scope "/api", FiftyTwo do
    pipe_through [:api]
  end
end
