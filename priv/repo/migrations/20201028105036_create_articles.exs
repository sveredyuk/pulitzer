defmodule Pulitzer.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :bucket_id, references(:buckets, on_delete: :delete_all), null: false
      add :content, :text, null: false
      add :tokens, {:array, :string}, null: false
      add :keywords, {:array, :string}, null: false
      add :words_count, :integer, default: 0, null: false
      add :metadata, :map, default: %{}, null: false

      timestamps()
    end

    create(unique_index(:articles, [:content, :bucket_id]))
    create(index(:articles, [:bucket_id]))
    create(index(:articles, [:words_count]))
    create(index(:articles, [:keywords]))
  end
end
