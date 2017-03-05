defmodule FiftyTwo.Game do
  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  schema "games" do
    field :title, :string
    field :appid, :integer
    field :image, :string
    field :platform, :string
    field :date_started, Ecto.Date
    field :date_completed, Ecto.Date
    field :playtime, :decimal

    belongs_to :challenge, FiftyTwo.Challenge

    timestamps()
  end

  @required_fields [:challenge_id, :title, :platform]
  @optional_fields [:appid, :image, :date_started, :date_completed, :playtime]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> prepare_changes(fn changeset ->
      timestamp = NaiveDateTime.utc_now
      assoc(changeset.data, :challenge)
      |> changeset.repo.update_all(set: [updated_at: timestamp])
      put_change(changeset, :updated_at, timestamp)
    end)
  end
end
