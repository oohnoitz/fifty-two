defmodule FiftyTwo.UserControllerTest do
  use FiftyTwo.ConnCase

  alias FiftyTwo.User
  @valid_attrs %{username: "username", password: "password", email: "test@test.localhost"}
  @invalid_attrs %{}

  describe "with anonymous" do
    test "lists all entries on index", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing users"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New user"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @valid_attrs
      assert redirected_to(conn) == user_path(conn, :index)
      assert html_response(conn, 302)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New user"
    end

    test "shows chosen resource", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200)
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = get conn, user_path(conn, :edit, user)
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = put conn, user_path(conn, :update, user), user: @valid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "deletes chosen resource", %{conn: conn} do
      user = Repo.insert! %User{}
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
      assert Repo.get(User, user.id)
    end
  end

  describe "with authorized user" do
    setup do
      user = Repo.insert!(%FiftyTwo.User{username: "username", password: "password", email: "test@test.localhost"})
      conn = login(user)
      {:ok, conn: conn, user: user}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing users"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New user"
    end

    test "shows chosen resource", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "Show user"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit user"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @valid_attrs
      assert redirected_to(conn) == user_path(conn, :show, user)
      assert Repo.get_by(User, %{username: "username", email: "test@test.localhost"})
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert redirected_to(conn) == user_path(conn, :show, user)
    end

    test "deletes chosen resource", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == user_path(conn, :index)
      refute Repo.get(User, user.id)
    end
  end

  describe "with unauthorized user" do
    setup do
      user = Repo.insert!(%FiftyTwo.User{id: 1, username: "username", password: "password", email: "test@test.localhost"})
      conn = login(Repo.insert!(%FiftyTwo.User{}))
      {:ok, conn: conn, user: user}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing users"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New user"
    end

    test "shows chosen resource", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "Show user"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @valid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "deletes chosen resource", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
      assert Repo.get(User, user.id)
    end
  end
end
