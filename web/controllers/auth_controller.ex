defmodule FiftyTwo.AuthController do
  use FiftyTwo.Web, :controller

  alias FiftyTwo.{Auth, User}

  def create(conn, %{"user" => params}) do
    case Auth.authenticate(params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logged In!")
        |> redirect(to: "/")
      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid Credentials.")
        |> render("login.html", changeset: User.changeset(%User{}))
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged Out!")
    |> redirect(to: "/")
  end

  def new(conn, _params) do
    render(conn, "login.html", changeset: User.changeset(%User{}))
  end
end
