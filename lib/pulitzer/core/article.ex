defmodule Pulitzer.Core.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pulitzer.Core.Bucket

  schema "articles" do
    belongs_to :bucket, Bucket

    field :content, :string
    field :tokens, {:array, :string}
    field :keywords, {:array, :string}
    field :words_count, :integer
    field :metadata, :map

    timestamps()
  end

  @doc false
  def create_changeset(article, attrs \\ %{}) do
    article
    |> cast(attrs, [:bucket_id, :content, :tokens, :keywords, :words_count, :metadata])
    |> validate_required([:bucket_id, :content, :tokens, :keywords, :words_count])
    |> unique_constraint(:content)
  end

  @doc false
  def content_changeset(article, attrs \\ %{}) do
    article
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> unique_constraint(:content)
  end
end
