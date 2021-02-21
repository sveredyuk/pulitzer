defmodule Pulitzer.Core.Bucket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buckets" do
    field :identifier, :string

    timestamps()
  end

  @identifier_regex ~r/^[a-z0-9-_]+$/

  @doc false
  def create_changeset(article, attrs \\ %{}) do
    article
    |> cast(attrs, [:identifier])
    |> validate_required([:identifier])
    |> validate_format(:identifier, @identifier_regex,
      message: "Only lower a-z, - and _ are allowed"
    )
    |> validate_length(:identifier, min: 5, max: 20)
    |> unique_constraint(:identifier, name: :buckets_identifier_index)
  end
end
