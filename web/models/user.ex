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

  @required_fields [:username, :password, :email]
  @optional_fields [:encrypted_password]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username, message: "Username is already taken.")
    |> unique_constraint(:email, message: "Email is already associated with another account.")
    |> generate_encrypted_password
  end

  @doc """
  Generates an encrypted password
  """
  def generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end
