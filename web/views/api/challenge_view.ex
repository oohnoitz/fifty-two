defmodule FiftyTwo.Api.ChallengeView do
  use FiftyTwo.Web, :view

  def render("index.json", %{challenges: challenges}) do
    %{
      challenges: Enum.map(challenges, &root_json/1)
    }
  end

  def render("show.json", %{challenge: challenge}) do
    %{
      challenge: root_json(challenge)
    }
  end

  defp root_json(data) do
    %{
      id: data.id,
      name: data.name,
      year: data.year,
      user: user_json(data.user),
      games: Enum.map(data.games, &game_json/1),
    }
  end

  defp game_json(game) do
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

  defp user_json(user) do
    %{
      id: user.id,
      username: user.username,
    }
  end
end
