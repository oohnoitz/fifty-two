defmodule FiftyTwo.Api.UserControllerTest do
  use FiftyTwo.ConnCase

  import FiftyTwo.Factory

  alias FiftyTwo.User

  @valid_attrs %{username: "username", email: "username@example.com"}
  @invalid_attrs %{username: "", email: ""}

  describe "as anon" do
    test "GET /api/v1/users", %{conn: conn} do
      conn = conn
      |> get(api_v1_user_path(conn, :index))

      assert json_response(conn, 200) == %{"users" => []}
    end

    test "GET /api/v1/users/:id", %{conn: conn} do
      user = insert(:user)

      conn = conn
      |> get(api_v1_user_path(conn, :show, user))

      assert json_response(conn, 200) == %{
        "user" => %{
          "id" => user.id,
          "username" => user.username,
        },
      }
    end

    test "POST /api/v1/users with valid data", %{conn: conn} do
      # IO.puts Map.put(@valid_attrs, "password", "password")
      conn = conn
      |> post(api_v1_user_path(conn, :create), user: Map.put(@valid_attrs, :password, "password"))

      assert Repo.get_by(User, @valid_attrs)
      assert response(conn, 201) == ""
    end

    test "POST /api/v1/users with invalid data", %{conn: conn} do
      conn = conn
      |> post(api_v1_user_path(conn, :create), user: @invalid_attrs)

      assert json_response(conn, 409) == %{
        "errors" => [
          %{"source" => %{"pointer" => "/data/attributes/password"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/username"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/email"}, "detail" => "can't be blank"},
        ]
      }
    end

    test "PUT /api/v1/users/:id with valid data", %{conn: conn} do
      user = insert(:user)

      conn = conn
      |> put(api_v1_user_path(conn, :update, user), user: @valid_attrs)

      refute Repo.get_by(User, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/users/:id with invalid data", %{conn: conn} do
      user = insert(:user)

      conn = conn
      |> put(api_v1_user_path(conn, :update, user), user: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "DELETE /api/v1/users/:id", %{conn: conn} do
      user = insert(:user)

      conn = conn
      |> delete(api_v1_user_path(conn, :delete, user))

      assert Repo.get(User, user.id)
      assert response(conn, 401) == ""
    end
  end

  describe "as user" do
    setup do
      user = insert(:user)
      conn = api_login(user)

      {:ok, conn: conn, user: user}
    end

    test "GET /api/v1/users", %{conn: conn, user: user} do
      conn = conn
      |> get(api_v1_user_path(conn, :index))

      assert json_response(conn, 200) == %{"users" => [%{"id" => user.id, "username" => user.username}]}
    end

    test "GET /api/v1/users/:id", %{conn: conn, user: user} do
      user = insert(:user)

      conn = conn
      |> get(api_v1_user_path(conn, :show, user))

      assert json_response(conn, 200) == %{
        "user" => %{
          "id" => user.id,
          "username" => user.username,
        }
      }
    end

    test "POST /api/v1/users with valid data", %{conn: conn} do
      conn = conn
      |> post(api_v1_user_path(conn, :create), user: Map.put(@valid_attrs, :password, "password"))

      user = Repo.get_by(User, @valid_attrs)

      assert user
      assert redirected_to(conn, 201) == api_v1_user_url(conn, :show, user)
      assert response(conn, 201) == ""
    end

    test "POST /api/v1/users with invalid data", %{conn: conn} do
      conn = conn
      |> post(api_v1_user_path(conn, :create), user: @invalid_attrs)

      assert json_response(conn, 409) == %{
        "errors" => [
          %{"source" => %{"pointer" => "/data/attributes/password"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/username"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/email"}, "detail" => "can't be blank"},
        ]
      }
    end

    test "PUT /api/v1/users/:id with valid data", %{conn: conn, user: user} do
      conn = conn
      |> put(api_v1_user_path(conn, :update, user), user: @valid_attrs)

      assert Repo.get_by(User, @valid_attrs)
      assert response(conn, 204) == ""
    end

    test "PUT /api/v1/users/:id with invalid data", %{conn: conn, user: user} do
      conn = conn
      |> put(api_v1_user_path(conn, :update, user), user: @invalid_attrs)

      assert json_response(conn, 422) == %{
        "errors" => [
          %{"source" => %{"pointer" => "/data/attributes/username"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/email"}, "detail" => "can't be blank"},
        ]
      }
    end

    test "DELETE /api/v1/users/:id", %{conn: conn, user: user} do
      conn = conn
      |> delete(api_v1_user_path(conn, :delete, user))

      refute Repo.get(User, user.id)
      assert response(conn, 204) == ""
    end
  end

  describe "as another user" do
    setup do
      user = insert(:user)
      conn = api_login(insert(:user))

      {:ok, conn: conn, user: user}
    end

    test "PUT /api/v1/users/:id with valid data", %{conn: conn, user: user} do
      user = insert(:user)

      conn = conn
      |> put(api_v1_user_path(conn, :update, user), user: @valid_attrs)

      refute Repo.get_by(User, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/users/:id with invalid data", %{conn: conn, user: user} do
      user = insert(:user)

      conn = conn
      |> put(api_v1_user_path(conn, :update, user), user: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "DELETE /api/v1/users/:id", %{conn: conn, user: user} do
      user = insert(:user)

      conn = conn
      |> delete(api_v1_user_path(conn, :delete, user))

      assert Repo.get(User, user.id)
      assert response(conn, 401) == ""
    end
  end
end
