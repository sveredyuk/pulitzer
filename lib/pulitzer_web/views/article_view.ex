defmodule PulitzerWeb.ArticleView do
  use PulitzerWeb, :view

  def render("show.json", %{article: article}) do
    %{
      article: article_payload(article)
    }
  end

  def render("created.json", %{article: article}) do
    %{
      action: "created",
      article: article_payload(article)
    }
  end

  def render("duplicate.json", %{original: original}) do
    %{
      action: "duplicate",
      original: article_payload(original)
    }
  end

  defp article_payload(article) do
    %{
      id: article.id,
      content: article.content,
      keywords: article.keywords,
      words_count: article.words_count,
      metadata: article.metadata
    }
  end
end
