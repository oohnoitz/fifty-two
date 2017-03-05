defmodule FiftyTwo.Web.GameControllerTest do
  use FiftyTwo.Web.ConnCase

  import FiftyTwo.Factory

  alias FiftyTwo.Game

  @valid_attrs %{appid: 52, date_completed: %{day: 17, month: 4, year: 2010}, date_started: %{day: 17, month: 4, year: 2010}, image: "image", platform: "platform", playtime: "120.5", title: "title"}
  @invalid_attrs %{title: "", platform: ""}

  describe "as anon" do
    test "GET /api/v1/games", %{conn: conn} do
      conn = conn
      |> get(api_game_path(conn, :index))

      assert json_response(conn, 200) == %{"games" => []}
    end

    test "GET /api/v1/games/:id", %{conn: conn} do
      user = insert(:user)
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> get(api_game_path(conn, :show, game))

      assert json_response(conn, 200) == %{
        "game" => %{
          "id" => game.id,
          "title" => game.title,
          "appid" => nil,
          "image" => nil,
          "platform" => game.platform,
          "date_started" => nil,
          "date_completed" => nil,
          "playtime" => nil,
          "challenge" => %{
            "id" => challenge.id,
            "name" => challenge.name,
            "year" => challenge.year,
            "user" => %{"id" => user.id, "username" => user.username},
            "updated_at" => NaiveDateTime.to_iso8601(challenge.updated_at),
          },
          "updated_at" => NaiveDateTime.to_iso8601(game.updated_at),
        },
      }
    end

    test "POST /api/v1/games with valid data", %{conn: conn} do
      conn = conn
      |> post(api_game_path(conn, :create), game: @valid_attrs)

      refute Repo.get_by(Game, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "POST /api/v1/games with invalid data", %{conn: conn} do
      conn = conn
      |> post(api_game_path(conn, :create), game: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/games/:id with valid data", %{conn: conn} do
      game = insert(:game)

      conn = conn
      |> put(api_game_path(conn, :update, game), game: @valid_attrs)

      refute Repo.get_by(Game, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/games/:id with invalid data", %{conn: conn} do
      game = insert(:game)

      conn = conn
      |> put(api_game_path(conn, :update, game), game: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "DELETE /api/v1/games/:id", %{conn: conn} do
      game = insert(:game)

      conn = conn
      |> delete(api_game_path(conn, :delete, game))

      assert Repo.get(Game, game.id)
      assert response(conn, 401) == ""
    end
  end

  describe "as user" do
    setup do
      user = insert(:user)
      conn = api_login(user)

      {:ok, conn: conn, user: user}
    end

    test "GET /api/v1/games", %{conn: conn} do
      conn = conn
      |> get(api_game_path(conn, :index))

      assert json_response(conn, 200) == %{"games" => []}
    end

    test "GET /api/v1/games/:id", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> get(api_game_path(conn, :show, game))

      assert json_response(conn, 200) == %{
        "game" => %{
          "id" => game.id,
          "title" => game.title,
          "appid" => nil,
          "image" => nil,
          "platform" => game.platform,
          "date_started" => nil,
          "date_completed" => nil,
          "playtime" => nil,
          "challenge" => %{
            "id" => challenge.id,
            "name" => challenge.name,
            "year" => challenge.year,
            "user" => %{"id" => user.id, "username" => user.username},
            "updated_at" => NaiveDateTime.to_iso8601(challenge.updated_at),
          },
          "updated_at" => NaiveDateTime.to_iso8601(game.updated_at),
        },
      }
    end

    test "POST /api/v1/games with valid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> post(api_game_path(conn, :create), game: Map.put(@valid_attrs, "challenge_id", challenge.id))

      game = Repo.get_by(Game, @valid_attrs)

      assert game
      assert redirected_to(conn, 201) == api_game_url(conn, :show, game)
      assert response(conn, 201) == ""
    end

    test "POST /api/v1/games with invalid data", %{conn: conn} do
      conn = conn
      |> post(api_game_path(conn, :create), game: @invalid_attrs)

      assert json_response(conn, 409) == %{
        "errors" => [
          %{"source" => %{"pointer" => "/data/attributes/challenge_id"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/title"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/platform"}, "detail" => "can't be blank"},
        ]
      }
    end

    test "PUT /api/v1/games/:id with valid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> put(api_game_path(conn, :update, game), game: @valid_attrs)

      assert Repo.get_by(Game, @valid_attrs)
      assert response(conn, 204) == ""
    end

    test "PUT /api/v1/games/:id with invalid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> put(api_game_path(conn, :update, game), game: @invalid_attrs)

      assert json_response(conn, 422) == %{
        "errors" => [
          %{"source" => %{"pointer" => "/data/attributes/title"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/platform"}, "detail" => "can't be blank"},
        ]
      }
    end

    test "DELETE /api/v1/games/:id", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> delete(api_game_path(conn, :delete, game))

      refute Repo.get(Game, game.id)
      assert response(conn, 204) == ""
    end
  end

  describe "as another user" do
    setup do
      user = insert(:user)
      conn = api_login(insert(:user))

      {:ok, conn: conn, user: user}
    end

    test "PUT /api/v1/games/:id with valid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> put(api_game_path(conn, :update, game), game: @valid_attrs)

      refute Repo.get_by(Game, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/games/:id with invalid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> put(api_game_path(conn, :update, game), game: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "DELETE /api/v1/games/:id", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> delete(api_game_path(conn, :delete, game))

      assert Repo.get(Game, game.id)
      assert response(conn, 401) == ""
    end
  end
end
