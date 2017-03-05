defmodule FiftyTwo.Web.ChallengeController do
  use FiftyTwo.Web, :controller

  alias FiftyTwo.Challenge

  plug :load_and_authorize_resource, model: Challenge, except: [:index], preload: [:user, :games]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _user) do
    challenges = Challenge
      |> preload([:user, :games])
      |> Repo.all
    render(conn, "index.json", challenges: challenges)
  end

  def create(conn, %{"challenge" => challenge_params}, user) do
    challenge_params = Map.put(challenge_params, "user_id", user.id)
    changeset = Challenge.changeset(%Challenge{}, challenge_params)

    case Repo.insert(changeset) do
      {:ok, challenge} ->
        conn
        |> put_status(201)
        |> put_resp_header("content-type", "application/json")
        |> put_resp_header("location", api_challenge_url(conn, :show, challenge))
        |> text("")
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(FiftyTwo.Web.ErrorView, "changeset.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}, _user) do
    challenge = conn.assigns.challenge
    render(conn, "show.json", challenge: challenge)
  end

  def update(conn, %{"id" => _id, "challenge" => challenge_params}, _user) do
    challenge_params = Map.delete(challenge_params, "user_id")

    challenge = conn.assigns.challenge
    changeset = Challenge.changeset(challenge, challenge_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_status(204)
        |> put_resp_header("content-type", "application/json")
        |> text("")
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(FiftyTwo.Web.ErrorView, "changeset.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}, _user) do
    challenge = conn.assigns.challenge
    case Repo.delete(challenge) do
      {:ok, _} ->
        conn
        |> put_status(204)
        |> put_resp_header("content-type", "application/json")
        |> text("")
    end
  end
end
