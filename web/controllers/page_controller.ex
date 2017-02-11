defmodule FiftyTwo.PageController do
  use FiftyTwo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
