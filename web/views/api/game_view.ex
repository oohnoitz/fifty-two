defmodule FiftyTwo.Api.GameView do
  use FiftyTwo.Web, :view

  def root_json(data) do
    %{
      title: data.title,
      appid: data.appid,
      image: data.image,
      platform: data.platform,
      date_started: data.date_started,
      date_completed: data.date_completed,
      playtime: data.playtime,
      challenge: challenge_json(data.challenge)
    }
  end

  def challenge_json(challenge) do
    %{
      id: challenge.id,
      name: challenge.name,
      year: challenge.year,
      user: user_json(challenge.user)
    }
  end

  def user_json(user) do
    %{
      id: user.id,
      username: user.username,
    }
  end

  def render("index.json", %{games: games}) do
    %{
      games: Enum.map(games, &root_json/1)
    }
  end

  def render("show.json", %{game: game}) do
    root_json(game)
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
