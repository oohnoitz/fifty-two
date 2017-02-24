defmodule FiftyTwo.Api.UserView do
  use FiftyTwo.Web, :view

  def render("index.json", %{users: users}) do
    %{
      users: Enum.map(users, &root_json/1),
    }
  end

  def render("show.json", %{user: user}) do
    %{
      user: root_json(user),
    }
  end

  defp root_json(data) do
    %{
      id: data.id,
      username: data.username,
    }
  end
end
