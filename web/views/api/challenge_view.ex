defmodule FiftyTwo.Api.ChallengeView do
  use FiftyTwo.Web, :view

  def root_json(data) do
    %{
      id: data.id,
      name: data.name,
      year: data.year,
      user: user_json(data.user),
      games: Enum.map(data.games, &game_json/1),
    }
  end

  def game_json(game) do
    %{
      id: game.id,
      title: game.title,
      appid: game.appid,
      image: game.image,
      platform: game.platform,
      date_started: game.date_started,
      date_completed: game.date_completed,
      playtime: game.playtime,
    }
  end

  def user_json(user) do
    %{
      id: user.id,
      username: user.username,
    }
  end

  def render("index.json", %{challenges: challenges}) do
    %{
      challenges: Enum.map(challenges, &root_json/1)
    }
  end

  def render("show.json", %{challenge: challenge}) do
    root_json(challenge)
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, error} ->
      %{
        source: %{pointer: "/data/attributes/#{field}"},
        detail: render_detail(error)
      }
    end)

    %{errors: errors}
  end


  def render_detail({message, values}) do
    Enum.reduce(values, message, fn {key, val}, acc ->
      String.replace(acc, "%{#{key}}", to_string(val))
    end)
  end
end
