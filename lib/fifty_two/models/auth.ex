defmodule FiftyTwo.Auth do
  alias FiftyTwo.{User, Repo}

  @doc """
  """
  def authenticate(params \\ %{}) do
    username = Map.get(params, "username", "")
    password = Map.get(params, "password", "")

    User
    |> Repo.get_by(username: username)
    |> validate_password(password)
  end

  defp validate_password(%{encrypted_password: hash} = user, password) do
    case Comeonin.Bcrypt.checkpw(password, hash) do
      true ->
        {:ok, user}
      false ->
        {:error, "Invalid Credentials."}
    end
  end

  defp validate_password(nil, _password) do
    {:error, "Invalid Credentials."}
  end
end
