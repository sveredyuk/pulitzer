defmodule Pulitzer.ScannerTest do
  use Pulitzer.DataCase

  alias Pulitzer.Core
  alias Pulitzer.Core.Scanner

  setup do
    {:ok, bucket} = Core.create_bucket("test_bucket")
    {:ok, article_1} = Core.create_article(bucket, %{content: "AAAA"})
    {:ok, article_2} = Core.create_article(bucket, %{content: "BBBB"})

    {:ok, candidate_1} = Core.build_article_token("aaaa")
    {:ok, candidate_2} = Core.build_article_token("bbbb")
    {:ok, candidate_3} = Core.build_article_token("cccc")

    %{
      bucket: bucket,
      article_1: article_1,
      article_2: article_2,
      candidate_1: candidate_1,
      candidate_2: candidate_2,
      candidate_3: candidate_3
    }
  end

  test "scan_all/2 returns first matched duplicaion", ctx do
    assert Scanner.scan_all(ctx.bucket, ctx.candidate_1).id == ctx.article_1.id
    assert Scanner.scan_all(ctx.bucket, ctx.candidate_2).id == ctx.article_2.id
    assert Scanner.scan_all(ctx.bucket, ctx.candidate_3) == nil
  end
end
