defmodule FiftyTwo.Factory do
  use ExMachina.Ecto, repo: FiftyTwo.Repo

  alias FiftyTwo.{User, Game, Challenge}

  def user_factory do
    %User{
      username: sequence(:username, &"user-#{&1}"),
      encrypted_password: Comeonin.Bcrypt.hashpwsalt("password"),
      email: sequence(:email, &"user-#{&1}@example.com"),
    }
  end

  def challenge_factory do
    %Challenge{
      name: sequence(:name, &"Challenge #{&1}"),
      year: Date.utc_today().year,
      user: build(:user),
      games: [],
    }
  end

  def game_factory do
    %Game{
      platform: "PC",
      title: sequence(:title, &"Game #{&1}"),
      challenge: build(:challenge),
    }
  end
end
