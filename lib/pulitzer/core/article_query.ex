defmodule Pulitzer.Core.ArticleQuery do
  import Ecto.Query, warn: false

  alias Pulitzer.Core.{Article, Bucket}

  def find_in_bucket_by_id(bucket_identifier, id) do
    from a in Article,
      inner_join: bucket in Bucket,
      on: bucket.identifier == ^bucket_identifier,
      where: a.id == ^id
  end

  def list(opts \\ []) do
    bucket_id = Keyword.get(opts, :bucket_id, 0)
    min_words = Keyword.get(opts, :min_words, 0)
    max_words = Keyword.get(opts, :max_words, 0)
    keywords = Keyword.get(opts, :keywords, [])

    from(
      a in Article,
      where: a.bucket_id == ^bucket_id,
      where: a.words_count >= ^min_words,
      where: a.words_count <= ^max_words,
      where: fragment("keywords @> ?::varchar[]", ^keywords)
    )
  end
end
