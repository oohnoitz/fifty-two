defmodule FiftyTwo.DataCase do
  @moduledoc """
  This module defines the test case to be used by
  model tests.

  You may define functions here to be used as helpers in
  your model tests. See `errors_on/2`'s definition as reference.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias FiftyTwo.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import FiftyTwo.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(FiftyTwo.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(FiftyTwo.Repo, {:shared, self()})
    end
    :ok
  end

  @doc """
  A helper that converts the changeset error messages
  for a given field into a list of strings for assertion:

      changeset = Blog.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset, :password)

  """
  def errors_on(changeset, field) do
    for {message, opts} <- Keyword.get_values(changeset.errors, field) do
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end
  end
end
