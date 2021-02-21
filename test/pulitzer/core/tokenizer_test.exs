defmodule Pulitzer.Core.EqualizerTest do
  use Pulitzer.DataCase

  alias Pulitzer.Core
  alias Pulitzer.Core.ArticleToken

  describe "build_article_token/1" do
    test "tokenize given text according to all rules" do
      text = """
        Text is About Apples and other fruits!
        An Apple is also know as IT company.
        A Fruit apple went, done, forgot verbs.
        Remove non-chars, remove commas, singulars;
        Plurals should become singulars.
        Keeps 2020 numbers
        Is Is Is is a A a An an An an or or or or or and and and and and and
      """

      expected_tokens = [
        "text",
        "i",
        "about",
        "apple",
        "and",
        "other",
        "fruit",
        "an",
        "apple",
        "i",
        "also",
        "know",
        "a",
        "it",
        "company",
        "a",
        "fruit",
        "apple",
        "go",
        "do",
        "forget",
        "verb",
        "remove",
        "non",
        "char",
        "remove",
        "comma",
        "singular",
        "plural",
        "should",
        "become",
        "singular",
        "keep",
        "2020",
        "number",
        "i",
        "i",
        "i",
        "i",
        "a",
        "a",
        "a",
        "an",
        "an",
        "an",
        "an",
        "or",
        "or",
        "or",
        "or",
        "or",
        "and",
        "and",
        "and",
        "and",
        "and",
        "and"
      ]

      {:ok, token} = Core.build_article_token(text)

      assert token == %ArticleToken{
               tokens: expected_tokens,
               words_count: 57,
               keywords: ["apple", "fruit", "remove", "singular", "2020"]
             }
    end
  end
end
