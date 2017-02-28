defmodule FiftyTwo.Router do
  use FiftyTwo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug FiftyTwo.Plug.CurrentUser
  end

  scope "/", FiftyTwo, as: :api do
    pipe_through [:api]

    get "/auth/verify", AuthController, :verify
    resources "/auth", AuthController, only: [:create, :delete]
    resources "/challenges", ChallengeController, except: [:new, :edit]
    resources "/games", GameController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end
end
