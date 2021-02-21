defmodule Pulitzer.CoreTest do
  use Pulitzer.DataCase

  alias Pulitzer.Core
  alias Core.{Article, ArticleToken}

  describe "buckets" do
    test "create_bucket/1 returns a new bucket record" do
      {:ok, bucket_1} = Core.create_bucket("my_bucket")
      {:ok, bucket_2} = Core.create_bucket("my-bucket")
      {:ok, bucket_3} = Core.create_bucket("my-bucket-3")

      assert bucket_1.identifier == "my_bucket"
      assert bucket_2.identifier == "my-bucket"
      assert bucket_3.identifier == "my-bucket-3"
    end

    test "create_bucket/1 requires bucket name" do
      {:error, changeset_1} = Core.create_bucket("")
      {:error, changeset_2} = Core.create_bucket(nil)

      assert changeset_1.errors == [identifier: {"can't be blank", [validation: :required]}]
      assert changeset_2.errors == [identifier: {"can't be blank", [validation: :required]}]
    end

    test "create_bucket/1 returns error for invalid bucket name" do
      {:error, changeset_1} = Core.create_bucket("my bucket")
      {:error, changeset_2} = Core.create_bucket("My_BuCkEt")
      {:error, changeset_3} = Core.create_bucket("my#bucket_$")

      assert changeset_1.errors == [
               identifier: {"Only lower a-z, - and _ are allowed", [validation: :format]}
             ]

      assert changeset_2.errors == [
               identifier: {"Only lower a-z, - and _ are allowed", [validation: :format]}
             ]

      assert changeset_3.errors == [
               identifier: {"Only lower a-z, - and _ are allowed", [validation: :format]}
             ]
    end

    test "create_bucket/1 returns error for invalid bucket name length" do
      {:error, changeset_1} = Core.create_bucket("abcd")
      {:error, changeset_2} = Core.create_bucket("abcdeabcdeabcdeabcde1")

      assert changeset_1.errors == [
               identifier: {
                 "should be at least %{count} character(s)",
                 [{:count, 5}, {:validation, :length}, {:kind, :min}, {:type, :string}]
               }
             ]

      assert changeset_2.errors == [
               identifier: {
                 "should be at most %{count} character(s)",
                 [{:count, 20}, {:validation, :length}, {:kind, :max}, {:type, :string}]
               }
             ]
    end

    test "create_bucket/1 returns error for taken bucket name" do
      {:ok, bucket} = Core.create_bucket("my_bucket")
      {:error, changeset} = Core.create_bucket("my_bucket")

      assert bucket.identifier == "my_bucket"

      assert changeset.errors == [
               identifier:
                 {"has already been taken",
                  [{:constraint, :unique}, {:constraint_name, "buckets_identifier_index"}]}
             ]
    end

    test "get_bucket/1 returns bucket for existing bucket identifier" do
      {:ok, bucket} = Core.create_bucket("test_bucket")
      result = Core.get_bucket!(bucket.identifier)

      assert result.id == bucket.id
    end
  end

  @valid_attrs %{content: "some content", metadata: %{any: "value"}}
  @invalid_attrs %{content: nil}

  describe "articles" do
    setup do
      {:ok, bucket} = Core.create_bucket("test_bucket")

      %{
        bucket: bucket
      }
    end

    test "build_article_token/1 returns tokenized map" do
      {:ok, token} = Core.build_article_token("Lorem ipsum dolor")

      assert token == %ArticleToken{
               tokens: ["lorem", "ipsum", "dolor"],
               keywords: ["dolor"],
               words_count: 3
             }
    end

    test "create_article/2 with valid data creates an article", %{bucket: bucket} do
      assert {:ok, %Article{} = article} = Core.create_article(bucket, @valid_attrs)
      assert article.content == "some content"
      assert article.metadata == %{any: "value"}
    end

    test "create_article/2 with invalid data returns error changeset", %{bucket: bucket} do
      assert %Ecto.Changeset{valid?: false} = Core.create_article(bucket, @invalid_attrs)
    end

    test "create_article/2 returns original article in case of duplication", %{bucket: bucket} do
      assert {:ok, %Article{} = original_article} =
               Core.create_article(bucket, %{content: "lorem"})

      assert original_article.content == "lorem"

      assert {:error, %Article{} = duplicated_article} =
               Core.create_article(bucket, %{content: "lorem"})

      assert duplicated_article.id == original_article.id
    end
  end
end
