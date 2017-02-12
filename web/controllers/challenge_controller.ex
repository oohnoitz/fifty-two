defmodule FiftyTwo.ChallengeController do
  use FiftyTwo.Web, :controller

  alias FiftyTwo.Challenge

  plug :load_and_authorize_resource, model: Challenge, except: [:show, :index]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, _user) do
    challenges = Repo.all(Challenge)
    render(conn, "index.html", challenges: challenges)
  end

  def new(conn, _params, _user) do
    changeset = Challenge.changeset(%Challenge{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"challenge" => challenge_params}, user) do
    challenge_params = Map.put(challenge_params, "user_id", user.id)
    changeset = Challenge.changeset(%Challenge{}, challenge_params)

    case Repo.insert(changeset) do
      {:ok, _challenge} ->
        conn
        |> put_flash(:info, "Challenge created successfully.")
        |> redirect(to: challenge_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _user) do
    challenge = Repo.get!(Challenge, id)
    render(conn, "show.html", challenge: challenge)
  end

  def edit(conn, %{"id" => id}, _user) do
    challenge = Repo.get!(Challenge, id)
    changeset = Challenge.changeset(challenge)
    render(conn, "edit.html", challenge: challenge, changeset: changeset)
  end

  def update(conn, %{"id" => id, "challenge" => challenge_params}, _user) do
    challenge_params = Map.delete(challenge_params, "user_id")

    challenge = Repo.get!(Challenge, id)
    changeset = Challenge.changeset(challenge, challenge_params)

    case Repo.update(changeset) do
      {:ok, challenge} ->
        conn
        |> put_flash(:info, "Challenge updated successfully.")
        |> redirect(to: challenge_path(conn, :show, challenge))
      {:error, changeset} ->
        render(conn, "edit.html", challenge: challenge, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    challenge = Repo.get!(Challenge, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(challenge)

    conn
    |> put_flash(:info, "Challenge deleted successfully.")
    |> redirect(to: challenge_path(conn, :index))
  end
end
