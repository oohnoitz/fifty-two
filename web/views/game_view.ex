defmodule FiftyTwo.GameView do
  use FiftyTwo.Web, :view

  def render("index.json", %{games: games}) do
    %{
      games: Enum.map(games, &root_json/1),
    }
  end

  def render("show.json", %{game: game}) do
    %{
      game: root_json(game)
    }
  end

  defp root_json(data) do
    %{
      id: data.id,
      title: data.title,
      appid: data.appid,
      image: data.image,
      platform: data.platform,
      date_started: data.date_started,
      date_completed: data.date_completed,
      playtime: data.playtime,
      challenge: challenge_json(data.challenge),
    }
  end

  defp challenge_json(challenge) do
    %{
      id: challenge.id,
      name: challenge.name,
      year: challenge.year,
      user: user_json(challenge.user),
    }
  end

  defp user_json(user) do
    %{
      id: user.id,
      username: user.username,
    }
  end
end
