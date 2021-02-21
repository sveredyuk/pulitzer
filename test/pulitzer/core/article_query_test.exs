defmodule Pulitzer.Core.ArticleQueryTest do
  use Pulitzer.DataCase

  alias Pulitzer.Core
  alias Pulitzer.Core.Article

  setup do
    {:ok, bucket} = Core.create_bucket("test_bucket")

    {:ok, article_1} =
      Article.create_changeset(%Article{}, %{
        bucket_id: bucket.id,
        content: "red",
        tokens: ["red"],
        words_count: 1,
        keywords: ["red"]
      })
      |> Repo.insert()

    {:ok, article_2} =
      Article.create_changeset(%Article{}, %{
        bucket_id: bucket.id,
        content: "green",
        tokens: ["green"],
        words_count: 2,
        keywords: ["red", "green"]
      })
      |> Repo.insert()

    {:ok, article_3} =
      Article.create_changeset(%Article{}, %{
        bucket_id: bucket.id,
        content: "blue",
        tokens: ["blue"],
        words_count: 3,
        keywords: ["red", "green", "blue"]
      })
      |> Repo.insert()

    {:ok, article_4} =
      Article.create_changeset(%Article{}, %{
        bucket_id: bucket.id,
        content: "yellow",
        tokens: ["yellow"],
        words_count: 4,
        keywords: ["red", "green", "blue", "yellow"]
      })
      |> Repo.insert()

    %{
      bucket: bucket,
      article_1: article_1,
      article_2: article_2,
      article_3: article_3,
      article_4: article_4
    }
  end

  describe "list/1" do
    test "returns empty list without options" do
      assert Core.list_articles() == []
    end

    test "returns all article_tokens within given words counts and keywords", ctx do
      # test max_words with 1 keyword
      result = Core.list_articles(bucket_id: ctx.bucket.id, max_words: 1, keywords: ["red"])

      assert Enum.count(result) == 1
      assert Enum.map(result, & &1.id) |> Enum.member?(ctx.article_1.id)

      # test words range with 2 keywords
      result =
        Core.list_articles(
          bucket_id: ctx.bucket.id,
          min_words: 2,
          max_words: 3,
          keywords: ["red", "green"]
        )

      assert Enum.count(result) == 2
      assert Enum.map(result, & &1.id) |> Enum.member?(ctx.article_2.id)
      assert Enum.map(result, & &1.id) |> Enum.member?(ctx.article_3.id)

      # test all words count range with 2 keywords
      result =
        Core.list_articles(
          bucket_id: ctx.bucket.id,
          min_words: 1,
          max_words: 5,
          keywords: ["blue"]
        )

      assert Enum.count(result) == 2
      assert Enum.map(result, & &1.id) |> Enum.member?(ctx.article_3.id)
      assert Enum.map(result, & &1.id) |> Enum.member?(ctx.article_4.id)

      # test all words count range with 4 keywords
      result =
        Core.list_articles(
          bucket_id: ctx.bucket.id,
          min_words: 1,
          max_words: 5,
          keywords: ["yellow", "green", "red", "blue"]
        )

      assert Enum.count(result) == 1
      assert Enum.map(result, & &1.id) |> Enum.member?(ctx.article_4.id)

      # test none result with words count range
      result =
        Core.list_articles(
          bucket_id: ctx.bucket.id,
          min_words: 5,
          max_words: 5,
          keywords: ["yellow"]
        )

      assert Enum.empty?(result)
    end
  end
end
