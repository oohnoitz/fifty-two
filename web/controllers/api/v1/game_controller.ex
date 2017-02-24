defmodule FiftyTwo.Api.GameController do
  use FiftyTwo.Web, :controller

  alias FiftyTwo.Game

  plug :load_and_authorize_resource, model: Game, except: [:index], preload: [challenge: :user]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _user) do
    games = Game
      |> preload([challenge: :user])
      |> Repo.all
    render(conn, "index.json", games: games)
  end

  def create(conn, %{"game" => game_params}, _user) do
    changeset = Game.changeset(%Game{}, game_params)

    case Repo.insert(changeset) do
      {:ok, game} ->
        conn
        |> put_status(201)
        |> put_resp_header("content-type", "application/json")
        |> put_resp_header("location", api_v1_game_url(conn, :show, game))
        |> text("")
      {:error, changeset} ->
        conn
        |> put_status(409)
        |> render(FiftyTwo.Api.ErrorView, "changeset.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _user) do
    game = conn.assigns.game
    render(conn, "show.json", game: game)
  end

  def update(conn, %{"id" => id, "game" => game_params}, _user) do
    game_params = Map.delete(game_params, "challenge_id")

    game = conn.assigns.game
    changeset = Game.changeset(game, game_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_status(204)
        |> put_resp_header("content-type", "application/json")
        |> text("")
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(FiftyTwo.Api.ErrorView, "changeset.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    game = conn.assigns.game
    case Repo.delete(game) do
      {:ok, _} ->
        conn
        |> put_status(204)
        |> put_resp_header("content-type", "application/json")
        |> text("")
    end
  end
end
