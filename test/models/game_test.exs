defmodule FiftyTwo.GameTest do
  use FiftyTwo.ModelCase

  alias FiftyTwo.Game

  @valid_attrs %{appid: 42, date_completed: %{day: 17, month: 4, year: 2010}, date_started: %{day: 17, month: 4, year: 2010}, image: "some content", platform: "some content", playtime: "120.5", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
