defmodule Pulitzer.Repo.Migrations.CreateBuckets do
  use Ecto.Migration

  def change do
    create table(:buckets) do
      add :identifier, :string, null: false

      timestamps()
    end

    create(unique_index(:buckets, [:identifier]))
  end
end
