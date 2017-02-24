defmodule FiftyTwo.AuthController do
  use FiftyTwo.Web, :controller

  alias FiftyTwo.Auth

  plug :scrub_params, "username" when action in [:create]
  plug :scrub_params, "password" when action in [:create]

  def create(conn, params) do
    case Auth.authenticate(params) do
      {:ok, user} ->
        api_conn = Guardian.Plug.api_sign_in(conn, user)

        {:ok, claims} = Guardian.Plug.claims(api_conn)
        jwt = Guardian.Plug.current_token(api_conn)
        exp = Map.get(claims, "exp")

        api_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("login.json", user: user, jwt: jwt)
      {:error, _} ->
        conn
        |> put_status(401)
        |> render("error.json", success: false, message: "Invalid Credentials.")
    end
  end

  def delete(conn, _params) do
    {status_code, response} = case Guardian.Plug.claims(conn) do
      {:ok, claims} ->
        jwt = Guardian.Plug.current_token(conn)
        Guardian.revoke!(jwt, claims)
        {200, %{success: true, message: "Logged Out!"}}
      {:error, :no_session} ->
        {401, %{success: false, message: "Logged Out!"}}
    end

    conn
    |> put_status(status_code)
    |> render("logout.json", response)
  end
end
