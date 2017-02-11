defmodule FiftyTwo.AuthTest do
  use FiftyTwo.ModelCase

  alias FiftyTwo.Auth

  setup do
    user = FiftyTwo.User.changeset_registration(%FiftyTwo.User{}, %{username: "username", password: "password", email: "test@test.localhost"})
    Repo.insert!(user)
    :ok
  end

  test "authenticate returns :ok" do
    {response, _} = Auth.authenticate(%{"username" => "username", "password" => "password"})
    assert response == :ok
  end

  test "authenticate returns :error" do
    {response, _} = Auth.authenticate(%{"username" => "password", "password" => "username"})
    assert response == :error
  end
end
