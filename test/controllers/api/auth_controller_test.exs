defmodule FiftyTwo.Api.AuthControllerTest do
  use FiftyTwo.ConnCase

  alias FiftyTwo.User

  setup do
    user = User.changeset_registration(%User{}, %{username: "username", password: "password", email: "test@test.localhost"})
    user = Repo.insert!(user)
    {:ok, user: user}
  end

  test "returns response with valid credentials" do
    conn = post build_conn(), api_v1_auth_path(build_conn(), :create), user: %{"username" => "username", "password" => "password"}
    assert json_response(conn, 200)
  end

  test "returns error with invalid credentials" do
    conn = post build_conn(), api_v1_auth_path(build_conn(), :create), user: %{"username" => "password", "password" => "username"}
    assert json_response(conn, 401)
  end

  test "returns response with valid token", %{user: user} do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

    conn = build_conn()
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> delete api_v1_auth_path(build_conn(), :delete, user)

    assert json_response(conn, 200)
  end

  test "returns error with invalid token", %{user: user} do
    conn = delete build_conn(), api_v1_auth_path(build_conn(), :delete, user)
    assert json_response(conn, 401)
  end
end
