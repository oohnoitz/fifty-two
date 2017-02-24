defmodule FiftyTwo.Api.ChallengeControllerTest do
  use FiftyTwo.ConnCase

  import FiftyTwo.Factory

  alias FiftyTwo.Challenge

  @valid_attrs %{name: "name", year: 2017}
  @invalid_attrs %{name: "", year: nil}

  describe "as anon" do
    test "GET /api/v1/challenges", %{conn: conn} do
      conn = conn
      |> get(api_v1_challenge_path(conn, :index))

      assert json_response(conn, 200) == %{"challenges" => []}
    end

    test "GET /api/v1/challenges/:id", %{conn: conn} do
      user = insert(:user)
      challenge = insert(:challenge, user: user)
      game = insert(:game, challenge: challenge)

      conn = conn
      |> get(api_v1_challenge_path(conn, :show, challenge))

      assert json_response(conn, 200) == %{
        "challenge" => %{
          "id" => challenge.id,
          "name" => challenge.name,
          "year" => challenge.year,
          "games" => [
            %{
              "id" => game.id,
              "title" => game.title,
              "appid" => nil,
              "image" => nil,
              "platform" => game.platform,
              "date_started" => nil,
              "date_completed" => nil,
              "playtime" => nil,
            },
          ],
          "user" => %{"id" => user.id, "username" => user.username}
        },
      }
    end

    test "POST /api/v1/challenges with valid data", %{conn: conn} do
      conn = conn
      |> post(api_v1_challenge_path(conn, :create), challenge: @valid_attrs)

      refute Repo.get_by(Challenge, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "POST /api/v1/challenges with invalid data", %{conn: conn} do
      conn = conn
      |> post(api_v1_challenge_path(conn, :create), challenge: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/challenges/:id with valid data", %{conn: conn} do
      challenge = insert(:challenge)

      conn = conn
      |> put(api_v1_challenge_path(conn, :update, challenge), challenge: @valid_attrs)

      refute Repo.get_by(Challenge, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/challenges/:id with invalid data", %{conn: conn} do
      challenge = insert(:challenge)

      conn = conn
      |> put(api_v1_challenge_path(conn, :update, challenge), challenge: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "DELETE /api/v1/challenges/:id", %{conn: conn} do
      challenge = insert(:challenge)

      conn = conn
      |> delete(api_v1_challenge_path(conn, :delete, challenge))

      assert Repo.get(Challenge, challenge.id)
      assert response(conn, 401) == ""
    end
  end

  describe "as user" do
    setup do
      user = insert(:user)
      conn = api_login(user)

      {:ok, conn: conn, user: user}
    end

    test "GET /api/v1/challenges", %{conn: conn} do
      conn = conn
      |> get(api_v1_challenge_path(conn, :index))

      assert json_response(conn, 200) == %{"challenges" => []}
    end

    test "GET /api/v1/challenges/:id", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> get(api_v1_challenge_path(conn, :show, challenge))

      assert json_response(conn, 200) == %{
        "challenge" => %{
          "id" => challenge.id,
          "name" => challenge.name,
          "year" => challenge.year,
          "games" => [],
          "user" => %{"id" => user.id, "username" => user.username}
        }
      }
    end

    test "POST /api/v1/challenges with valid data", %{conn: conn} do
      conn = conn
      |> post(api_v1_challenge_path(conn, :create), challenge: @valid_attrs)

      challenge = Repo.get_by(Challenge, @valid_attrs)

      assert challenge
      assert redirected_to(conn, 201) == api_v1_challenge_url(conn, :show, challenge)
      assert response(conn, 201) == ""
    end

    test "POST /api/v1/challenges with invalid data", %{conn: conn} do
      conn = conn
      |> post(api_v1_challenge_path(conn, :create), challenge: @invalid_attrs)

      assert json_response(conn, 409) == %{
        "errors" => [
          %{"source" => %{"pointer" => "/data/attributes/name"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/year"}, "detail" => "can't be blank"},
        ]
      }
    end

    test "PUT /api/v1/challenges/:id with valid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> put(api_v1_challenge_path(conn, :update, challenge), challenge: @valid_attrs)

      assert Repo.get_by(Challenge, @valid_attrs)
      assert response(conn, 204) == ""
    end

    test "PUT /api/v1/challenges/:id with invalid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> put(api_v1_challenge_path(conn, :update, challenge), challenge: @invalid_attrs)

      assert json_response(conn, 422) == %{
        "errors" => [
          %{"source" => %{"pointer" => "/data/attributes/name"}, "detail" => "can't be blank"},
          %{"source" => %{"pointer" => "/data/attributes/year"}, "detail" => "can't be blank"},
        ]
      }
    end

    test "DELETE /api/v1/challenges/:id", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> delete(api_v1_challenge_path(conn, :delete, challenge))

      refute Repo.get(Challenge, challenge.id)
      assert response(conn, 204) == ""
    end
  end

  describe "as another user" do
    setup do
      user = insert(:user)
      conn = api_login(insert(:user))

      {:ok, conn: conn, user: user}
    end

    test "PUT /api/v1/challenges/:id with valid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> put(api_v1_challenge_path(conn, :update, challenge), challenge: @valid_attrs)

      refute Repo.get_by(Challenge, @valid_attrs)
      assert response(conn, 401) == ""
    end

    test "PUT /api/v1/challenges/:id with invalid data", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> put(api_v1_challenge_path(conn, :update, challenge), challenge: @invalid_attrs)

      assert response(conn, 401) == ""
    end

    test "DELETE /api/v1/challenges/:id", %{conn: conn, user: user} do
      challenge = insert(:challenge, user: user)

      conn = conn
      |> delete(api_v1_challenge_path(conn, :delete, challenge))

      assert Repo.get(Challenge, challenge.id)
      assert response(conn, 401) == ""
    end
  end
end
