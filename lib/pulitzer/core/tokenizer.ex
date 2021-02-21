defmodule Pulitzer.Core.Tokenizer do
  alias Pulitzer.Inspector
  alias Pulitzer.Core.{ArticleToken, IrregularVerbs, KeywordsFilter}

  @s " "
  @e ""

  alias Pulitzer.AsycProcess

  def build_article_token(""), do: :error
  def build_article_token(nil), do: :error

  def build_article_token(content) do
    token =
      content
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]/, @s)
      |> String.split(@s)
      |> Enum.filter(&remove_empty/1)
      |> AsycProcess.run(&Inflex.singularize/1)
      |> AsycProcess.run(&IrregularVerbs.normalize/1)
      |> build_token_struct

    {:ok, token}
  end

  defp remove_empty(@e), do: false
  defp remove_empty(_), do: true

  defp build_token_struct(tokens_list) do
    %ArticleToken{
      tokens: tokens_list,
      words_count: Enum.count(tokens_list),
      keywords: extract_keywords(tokens_list)
    }
  end

  defp extract_keywords(token_list) when is_list(token_list) do
    {words_count, keywords_quota} = extract_keywords_quota(token_list)

    token_list
    |> KeywordsFilter.run()
    |> Enum.reduce(%{}, &count_words/2)
    |> Enum.map(&words_count_to_map(&1, words_count))
    |> Enum.sort_by(& &1.weight, :desc)
    |> Inspector.inspect("Count words")
    |> Enum.take(keywords_quota)
    |> Enum.map(& &1.word)
    |> Inspector.inspect("Keywords")
  end

  defp count_words(word, acc) do
    Map.update(acc, word, 1, &(&1 + 1))
  end

  # How precise we should be for % word of all tokens
  @words_weight_precision 4
  defp words_count_to_map({word, count}, words_count) do
    %{
      word: word,
      count: count,
      weight: Float.round(count / words_count, @words_weight_precision)
    }
  end

  # Need only 10% of most frequent keywords
  @keywords_quota 0.1
  defp extract_keywords_quota(list) do
    count = Enum.count(list)

    quota =
      (count * @keywords_quota)
      |> trunc()
      |> min_quota()

    {count, quota}
  end

  def min_quota(0), do: 1
  def min_quota(val), do: val
end
