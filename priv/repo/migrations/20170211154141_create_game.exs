defmodule FiftyTwo.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :challenge_id, references(:challenges)
      add :title, :string
      add :appid, :integer
      add :image, :string
      add :platform, :string
      add :date_started, :date
      add :date_completed, :date
      add :playtime, :decimal

      timestamps()
    end

    create index(:games, [:challenge_id])
  end
end
