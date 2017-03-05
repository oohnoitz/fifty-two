defmodule FiftyTwo.User do
  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  @derive {Poison.Encoder, only: [:id, :username, :email]}

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :email, :string

    has_many :challenges, FiftyTwo.Challenge

    timestamps()
  end

  @required_fields [:username, :email]
  @optional_fields [:password, :encrypted_password]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username, message: "Username is already taken.")
    |> unique_constraint(:email, message: "Email is already associated with another account.")
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
    |> generate_encrypted_password
  end

  @doc """
  """
  def changeset_registration(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
  end

  def set_password(struct, password) do
    struct
    |> changeset(%{"password" => password})
    |> FiftyTwo.Repo.update!
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end
