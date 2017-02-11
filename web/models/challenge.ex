defmodule FiftyTwo.Challenge do
  use FiftyTwo.Web, :model

  schema "challenges" do
    field :name, :string
    field :year, :integer

    belongs_to :user, FiftyTwo.User
    has_many :games, FiftyTwo.Game

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :year])
    |> validate_required([:name, :year])
  end
end
