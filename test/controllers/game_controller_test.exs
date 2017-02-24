defmodule FiftyTwo.GameControllerTest do
  use FiftyTwo.ConnCase

  alias FiftyTwo.Game
  @valid_attrs %{appid: 52, date_completed: %{day: 17, month: 4, year: 2010}, date_started: %{day: 17, month: 4, year: 2010}, image: "image", platform: "platform", playtime: "120.5", title: "title"}
  @invalid_attrs %{}

  describe "with anonymous" do
    setup do
      Repo.insert!(%FiftyTwo.User{id: 1, username: "username", password: "password", email: "test@test.localhost"})
      Repo.insert!(%FiftyTwo.Challenge{id: 1, user_id: 1, name: "name", year: 2017})
      :ok
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, game_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing games"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, game_path(conn, :new)
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, game_path(conn, :create), game: @valid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, game_path(conn, :create), game: @invalid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "shows chosen resource", %{conn: conn} do
      game = Repo.insert! %Game{}
      conn = get conn, game_path(conn, :show, game)
      assert html_response(conn, 200) =~ "Show game"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, game_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{conn: conn} do
      game = Repo.insert! %Game{}
      conn = get conn, game_path(conn, :edit, game)
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      game = Repo.insert! %Game{}
      conn = put conn, game_path(conn, :update, game), game: @valid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      game = Repo.insert! %Game{}
      conn = put conn, game_path(conn, :update, game), game: @invalid_attrs
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
    end

    test "deletes chosen resource", %{conn: conn} do
      game = Repo.insert! %Game{}
      conn = delete conn, game_path(conn, :delete, game)
      assert redirected_to(conn) == "/"
      assert html_response(conn, 302)
      assert Repo.get(Game, game.id)
    end
  end

  describe "with authorized user" do
    setup do
      user = Repo.insert!(%FiftyTwo.User{username: "username", password: "password", email: "test@test.localhost"})
      data = Repo.insert!(%FiftyTwo.Challenge{user_id: user.id, name: "name", year: 2017})
      conn = login(user)
      {:ok, conn: conn, data: data}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, game_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing games"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, game_path(conn, :new)
      assert html_response(conn, 200)
    end

    test "creates resource and redirects when data is valid", %{conn: conn, data: data} do
      conn = post conn, game_path(conn, :create), game: Map.put(@valid_attrs, "challenge_id", data.id)
      assert redirected_to(conn) == game_path(conn, :index)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, game_path(conn, :create), game: @invalid_attrs
      assert html_response(conn, 200)
    end

    test "shows chosen resource", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = get conn, game_path(conn, :show, game)
      assert html_response(conn, 200) =~ "Show game"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, game_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = get conn, game_path(conn, :edit, game)
      assert html_response(conn, 200)
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = put conn, game_path(conn, :update, game), game: Map.put(@valid_attrs, "challenge_id", data.id)
      assert redirected_to(conn) == game_path(conn, :show, game)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = put conn, game_path(conn, :update, game), game: @invalid_attrs
      assert html_response(conn, 200)
    end

    test "deletes chosen resource", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = delete conn, game_path(conn, :delete, game)
      assert redirected_to(conn) == game_path(conn, :index)
      refute Repo.get(Game, game.id)
    end
  end

  describe "with unauthorized user" do
    setup do
      user = Repo.insert!(%FiftyTwo.User{username: "username", password: "password", email: "test@test.localhost"})
      data = Repo.insert!(%FiftyTwo.Challenge{user_id: user.id, name: "name", year: 2017})
      conn = login(Repo.insert!(%FiftyTwo.User{}))
      {:ok, conn: conn, data: data}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, game_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing games"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, game_path(conn, :new)
      assert html_response(conn, 200)
    end

    test "creates resource and redirects when data is valid", %{conn: conn, data: data} do
      conn = post conn, game_path(conn, :create), game: Map.put(@valid_attrs, "challenge_id", data.id)
      assert redirected_to(conn) == game_path(conn, :index)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, game_path(conn, :create), game: @invalid_attrs
      assert html_response(conn, 200)
    end

    # @TODO: look into why this test is failing
    # test "shows chosen resource", %{conn: conn, data: data} do
    #   game = Repo.insert! %Game{challenge_id: data.id}
    #   conn = get conn, game_path(conn, :show, game)
    #   assert html_response(conn, 200) =~ "Show game"
    # end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, game_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = get conn, game_path(conn, :edit, game)
      assert redirected_to(conn) == "/"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = put conn, game_path(conn, :update, game), game: Map.put(@valid_attrs, "challenge_id", data.id)
      assert redirected_to(conn) == "/"
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = put conn, game_path(conn, :update, game), game: @invalid_attrs
      assert redirected_to(conn) == "/"
    end

    test "deletes chosen resource", %{conn: conn, data: data} do
      game = Repo.insert! %Game{challenge_id: data.id}
      conn = delete conn, game_path(conn, :delete, game)
      assert redirected_to(conn) == "/"
      assert Repo.get(Game, game.id)
    end
  end
end
