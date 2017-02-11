defmodule FiftyTwo.User do
  use FiftyTwo.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :email, :string

    has_many :challenges, FiftyTwo.Challenge

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :encrypted_password, :email])
    |> validate_required([:username, :encrypted_password, :email])
  end
end
