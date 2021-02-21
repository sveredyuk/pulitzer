defmodule Pulitzer.Core do
  alias Pulitzer.Repo

  alias Pulitzer.Core.{
    Article,
    ArticleQuery,
    Bucket,
    Detector,
    Scanner,
    Tokenizer
  }

  def create_bucket(identifier) do
    %Bucket{}
    |> Bucket.create_changeset(%{identifier: identifier})
    |> Repo.insert()
  end

  def get_bucket!(bucket_identifier) do
    Repo.get_by!(Bucket, identifier: bucket_identifier)
  end

  defdelegate build_article_token(content), to: Tokenizer
  defdelegate detect_duplications(original_tokens, candidate_tokens), to: Detector
  defdelegate scan_all(bucket, candidate_tokens), to: Scanner

  def list_articles(opts \\ []) do
    opts
    |> ArticleQuery.list()
    |> Repo.all()
  end

  def get_article(%Bucket{} = bucket, id) do
    bucket.identifier
    |> ArticleQuery.find_in_bucket_by_id(id)
    |> Repo.one!()
  end

  def create_article(%Bucket{} = bucket, %{content: content} = attrs) do
    with %Ecto.Changeset{valid?: true} <- Article.content_changeset(%Article{}, attrs),
         {:ok, article_token} <- build_article_token(content),
         article_attrs <- Map.from_struct(article_token) |> Map.merge(attrs),
         %Ecto.Changeset{valid?: true} = changeset <-
           Article.create_changeset(%Article{bucket_id: bucket.id}, article_attrs),
         original_article <- scan_all(bucket, article_token),
         {:ok, article} <- maybe_create_article(original_article, changeset) do
      {:ok, article}
    else
      error -> error
    end
  end

  defp maybe_create_article(nil, changeset) do
    Repo.insert(changeset)
  end

  defp maybe_create_article(original_article, _), do: {:error, original_article}
end
