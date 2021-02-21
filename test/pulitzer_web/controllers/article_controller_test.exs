defmodule PulitzerWeb.ArticleControllerTest do
  use PulitzerWeb.ConnCase

  alias Pulitzer.Core

  @create_attrs %{content: "some content", metadata: %{my: "key"}}
  @invalid_attrs %{content: nil}

  setup %{conn: conn} do
    {:ok, bucket} = Core.create_bucket("test_bucket")

    %{
      conn: put_req_header(conn, "accept", "application/json"),
      bucket: bucket
    }
  end

  describe "show" do
    test "render article", %{conn: conn, bucket: bucket} do
      {:ok, article} = Core.create_article(bucket, %{content: "A"})

      conn = get(conn, Routes.article_path(conn, :show, bucket.identifier, article.id))

      assert json_response(conn, 200) == %{
               "article" => %{
                 "id" => article.id,
                 "content" => article.content,
                 "keywords" => article.keywords,
                 "words_count" => article.words_count,
                 "metadata" => %{}
               }
             }
    end

    test "renders 404 when article is not found", %{conn: conn, bucket: bucket} do
      assert_error_sent 404, fn ->
        conn = get(conn, Routes.article_path(conn, :show, bucket.identifier, 1))
        assert conn.status == 404
      end
    end
  end

  describe "create" do
    test "renders article when data is valid", %{conn: conn, bucket: bucket} do
      conn = post(conn, Routes.article_path(conn, :create, bucket.identifier), @create_attrs)

      assert %{
               "action" => "created",
               "article" => %{
                 "id" => _id,
                 "content" => "some content",
                 "metadata" => %{"my" => "key"}
               }
             } = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn, bucket: bucket} do
      conn = post(conn, Routes.article_path(conn, :create, bucket.identifier, @invalid_attrs))

      assert json_response(conn, 422)["errors"] == %{
               "content" => ["can't be blank"]
             }
    end
  end
end
