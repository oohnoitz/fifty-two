defmodule FiftyTwo.UserTest do
  use FiftyTwo.ModelCase

  alias FiftyTwo.User

  @valid_attrs %{username: "username", password: "password", email: "test@test.localhost"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset, email invalid format" do
    changeset = User.changeset(
      %User{}, Map.put(@invalid_attrs, :email, "test.localhost")
    )
    refute changeset.valid?
  end

  test "changeset_registration is valid" do
    changeset = User.changeset_registration(%User{}, @valid_attrs)
    assert changeset.changes.encrypted_password
    assert changeset.valid?
  end

  test "changeset_registration, password too short" do
    changeset = User.changeset_registration(
      %User{}, Map.put(@valid_attrs, :password, "12345")
    )
    assert changeset.changes.encrypted_password
    refute changeset.valid?
  end
end
