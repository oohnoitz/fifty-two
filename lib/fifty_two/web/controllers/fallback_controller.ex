defmodule FiftyTwo.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use FiftyTwo.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(422)
    |> render(FiftyTwo.Web.ErrorView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> render(FiftyTwo.Web.ErrorView, :"404")
  end
end
