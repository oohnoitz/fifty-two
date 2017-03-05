defmodule FiftyTwo.Web.UserController do
  use FiftyTwo.Web, :controller

  alias FiftyTwo.User

  plug :load_and_authorize_resource, model: User, except: [:index]

  action_fallback FiftyTwo.Web.FallbackController

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset_registration(%User{}, user_params)

    with {:ok, %User{} = user} <- Repo.insert(changeset) do
      conn
      |> put_status(201)
      |> put_resp_header("content-type", "application/json")
      |> put_resp_header("location", api_user_url(conn, :show, user))
      |> text("")
    end
  end

  def show(conn, %{"id" => _id}) do
    user = conn.assigns.user
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => _id, "user" => user_params}) do
    user = conn.assigns.user
    changeset = User.changeset(user, user_params)

    with {:ok, %User{} = user} <- Repo.update(changeset) do
      conn
      |> put_status(204)
      |> put_resp_header("content-type", "application/json")
      |> text("")
    end
  end

  def delete(conn, %{"id" => _id}) do
    user = conn.assigns.user
    with {:ok, %User{}} <- Repo.delete(user) do
      conn
      |> put_status(204)
      |> put_resp_header("content-type", "application/json")
      |> text("")
    end
  end
end
