defmodule FiftyTwo.Web.ControllerHelper do
  use Phoenix.Controller
  import Plug.Conn, only: [put_resp_header: 3, put_status: 2, halt: 1]

  def handle_not_found(conn) do
    case get_format(conn) do
      # "html" ->
      #   conn
      #   |> put_flash(:error, "That resource does not exist!")
      #   |> put_status(404)
      "json" ->
        conn
        |> put_status(404)
        |> put_resp_header("content-type", "application/json")
        |> text("")
        |> halt
    end
  end

  def handle_unauthorized(conn) do
    case get_format(conn) do
      # "html" ->
      #   conn
      #   |> put_flash(:error, "You are not authorized to access that resource!")
      #   |> redirect(to: "/")
      "json" ->
        conn
        |> put_status(401)
        |> put_resp_header("content-type", "application/json")
        |> text("")
    end
    |> halt
  end
end
