defmodule FiftyTwo.Repo.Migrations.CreateChallenge do
  use Ecto.Migration

  def change do
    create table(:challenges) do
      add :user_id, references(:users)
      add :name, :string
      add :year, :integer

      timestamps()
    end

    create index(:challenges, [:user_id])
  end
end
