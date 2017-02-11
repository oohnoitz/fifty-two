defmodule FiftyTwo.ChallengeTest do
  use FiftyTwo.ModelCase

  alias FiftyTwo.Challenge

  @valid_attrs %{name: "some content", year: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Challenge.changeset(%Challenge{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Challenge.changeset(%Challenge{}, @invalid_attrs)
    refute changeset.valid?
  end
end
