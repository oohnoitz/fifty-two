defmodule FiftyTwo.AuthControllerTeset do
  use FiftyTwo.ConnCase

  alias FiftyTwo.User

  setup do
    user = User.changeset_registration(%User{}, %{username: "username", password: "password", email: "test@test.localhost"})
    Repo.insert!(user)
    :ok
  end

  test "creates a valid authentication", %{conn: conn} do
    conn = post conn, auth_path(conn, :create), user: %{"username" => "username", "password" => "password"}
    assert html_response(conn, 302)
  end

  test "does not create a valid authentication", %{conn: conn} do
    conn = post conn, auth_path(conn, :create), user: %{"username" => "password", "password" => "username"}
    assert html_response(conn, 200) =~ "Invalid Credentials."
  end

  test "deletes an authentication session", %{conn: conn} do
    conn = get conn, auth_path(conn, :delete)
    assert html_response(conn, 302)
  end

  test "renders an authentication form", %{conn: conn} do
    conn = get conn, auth_path(conn, :new)
    assert html_response(conn, 200)
  end
end
