defmodule FiftyTwo.Api.AuthControllerTest do
  use FiftyTwo.ConnCase

  import FiftyTwo.Factory

  alias FiftyTwo.User

  setup do
    user = insert(:user) |> User.set_password("password")
    conn = build_conn()

    {:ok, conn: conn, user: user}
  end

  test "returns response with valid credentials", %{conn: conn, user: user} do
    conn = conn
    |> post(api_v1_auth_path(conn, :create), %{"username" => user.username, "password" => "password"})

    assert json_response(conn, 200)
  end

  test "returns error with invalid credentials", %{conn: conn, user: user} do
    conn = conn
    |> post(api_v1_auth_path(conn, :create), %{"username" => user.password, "password" => "username"})

    assert json_response(conn, 401)
  end

  test "returns response with valid token", %{conn: conn, user: user} do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> delete(api_v1_auth_path(conn, :delete, user))

    assert json_response(conn, 200)
  end

  test "returns error with invalid token", %{conn: conn, user: user} do
    conn = conn
    |> delete(api_v1_auth_path(conn, :delete, user))

    assert json_response(conn, 401)
  end
end
