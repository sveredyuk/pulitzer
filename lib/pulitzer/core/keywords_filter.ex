defmodule Pulitzer.Core.KeywordsFilter do
  # https://en.wiktionary.org/wiki/Appendix:Common_short_words_in_the_English_language
  @ignore_keywords [
    "a",
    "i",
    "ad",
    "am",
    "an",
    "as",
    "at",
    "be",
    "ha",
    "id",
    "if",
    "in",
    "is",
    "it",
    "of",
    "on",
    "or",
    "pi",
    "so",
    "to",
    "the",
    "and"
  ]

  def run(words_list) do
    words_list
    |> Enum.reject(fn word ->
      Enum.member?(@ignore_keywords, word)
    end)
  end
end
