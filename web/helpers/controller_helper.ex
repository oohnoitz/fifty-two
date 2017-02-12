defmodule FiftyTwo.ControllerHelper do
  use Phoenix.Controller
  import Plug.Conn, only: [halt: 1]

  def handle_not_found(conn) do
    conn
    |> put_flash(:error, "That resource does not exist!")
    |> redirect(to: "/")
    |> halt
  end

  def handle_unauthorized(conn) do
    conn
    |> put_flash(:error, "You are not authorized to access that resource!")
    |> redirect(to: "/")
    |> halt
  end
end
