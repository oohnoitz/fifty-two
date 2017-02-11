defmodule FiftyTwo.Challenge do
  use FiftyTwo.Web, :model

  schema "challenges" do
    field :name, :string
    field :year, :integer

    belongs_to :user, FiftyTwo.User
    has_many :games, FiftyTwo.Game

    timestamps()
  end

  @required_fields [:user_id, :name, :year]
  @optional_fields []

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
