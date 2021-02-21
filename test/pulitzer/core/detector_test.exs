defmodule Pulitzer.Core.DetectorTest do
  use Pulitzer.DataCase

  alias Pulitzer.Core

  describe "detect_duplications/2" do
    test "low match" do
      {:ok, original} =
        Core.build_article_token(
          "What can go wrong with this approach as I tried to use my best software development skills"
        )

      {:ok, candidate} =
        Core.build_article_token(
          "Nothing wrong with this approach. Just you are not the smartest guy in the World"
        )

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 35.29
    end

    test "50 match" do
      {:ok, original} = Core.build_article_token("A A A A A A A A A A A A A A A A A A A A")
      {:ok, candidate} = Core.build_article_token("A B A B A B A B A B A B A B A B A B A B")

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 50
    end

    test "66.67 match" do
      {:ok, original} = Core.build_article_token("Lorem ipsum dolor")
      {:ok, candidate} = Core.build_article_token("Lorem ipsum amet")

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 66.67
    end

    test "80 match" do
      {:ok, original} = Core.build_article_token("A B C D E A B C D E A B C D E A B C D E")
      {:ok, candidate} = Core.build_article_token("A X F D J A X F D J A X F D E A X F D E")

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 50
    end

    test "90 match" do
      {:ok, original} = Core.build_article_token("A A A A A A A A A A")
      {:ok, candidate} = Core.build_article_token("A A A A A A A A A B")

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 90
    end

    test "95 match" do
      {:ok, original} = Core.build_article_token("A A A A A A A A A A A A A A A A A A A A")
      {:ok, candidate} = Core.build_article_token("A A A A A A A A A A A A A A A A A A A B")

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 95
    end

    test "100 match" do
      {:ok, original} = Core.build_article_token("A A A A A A A A A A")
      {:ok, candidate} = Core.build_article_token("a a a a a a a a a a")

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 100
    end

    test "mirror match" do
      {:ok, original} = Core.build_article_token("hello world")
      {:ok, candidate} = Core.build_article_token("world hello")

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 50
    end

    test "~95 match with real article ~100 words" do
      original_text = """
      Once autumn begins in full, people all over the northern half of the US (and parts of California) decide that the most exciting weekend activity imaginable is driving out of the city to an apple orchard to pick their own apples.
      It’s always a thing that sounds cool and ends up being a more mid-level fun thing — unless there are fresh apple cider donuts on hand, in which case it moves waaaaaay up the “fall weekend activity ranking.
      Regardless of whether or not you’re hitting orchards for a little you-pay-them-type manual labor anytime soon, apples are synonymous with autumn.
      Fall is the time for apple pie, apple cider, and, perhaps most importantly, applejack and other apple-flavored spirits.
      """

      candidate_text = """
      Once winter begins in full, people all over the northern and sourthern half of the US (and parts of California state) decide that the most exciting weekend activity imaginable is going out of the city to an apple orchard to pick their own apples.
      It’s always a thing that sounds cool and ends up being a more mid-level fun thing — unless there are fresh apple cider donuts on hand, in which case it moves waaaaaay up the “fall weekend activity ranking.
      Regardless of whether or not you’re hitting orchards for a little you-pay-them-type manual labor anytime soon, apples are synonymous with autumn.
      Fall is the time for apple pie, apple cider, and, perhaps most importantly, applejack and other apple-flavored spirits.
      """

      {:ok, original} = Core.build_article_token(original_text)
      {:ok, candidate} = Core.build_article_token(candidate_text)

      assert Core.detect_duplications(original.tokens, candidate.tokens) == 95.97
    end
  end
end
