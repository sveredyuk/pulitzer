defmodule PulitzerWeb.ArticleController do
  use PulitzerWeb, :controller

  alias Pulitzer.Core
  alias Pulitzer.Core.Article

  action_fallback PulitzerWeb.FallbackController

  def show(conn, %{"bucket_identifier" => bucket_identifier, "id" => id}) do
    bucket = Core.get_bucket!(bucket_identifier)
    article = Core.get_article(bucket, id)
    render(conn, "show.json", article: article)
  end

  def create(conn, %{
        "bucket_identifier" => bucket_identifier,
        "content" => content,
        "metadata" => metadata
      }) do
    process_create(conn, bucket_identifier, %{content: content, metadata: metadata})
  end

  def create(conn, %{"bucket_identifier" => bucket_identifier, "content" => content}) do
    process_create(conn, bucket_identifier, %{content: content})
  end

  defp process_create(conn, bucket_identifier, attrs) do
    bucket = Core.get_bucket!(bucket_identifier)

    Core.create_article(bucket, attrs)
    |> case do
      {:ok, %Article{} = article} ->
        conn
        |> put_status(:created)
        |> render("created.json", article: article)

      %Ecto.Changeset{valid?: false} = changeset ->
        {:error, changeset}

      {:error, original} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("duplicate.json", original: original)
    end
  end
end
