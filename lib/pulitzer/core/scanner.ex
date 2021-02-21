defmodule Pulitzer.Core.Scanner do
  alias Pulitzer.Network
  alias Pulitzer.{Core, Inspector}
  alias Core.{ArticleToken, Bucket}

  @max_duplication_level String.to_integer(System.get_env("PULITZER_DUPLICATION_LEVEL", "90"))

  def scan_all(_, nil), do: nil
  def scan_all(_, ""), do: nil

  def scan_all(%Bucket{} = bucket, %ArticleToken{} = candidate) do
    Inspector.inspect(@max_duplication_level, "Max duplication level")

    candidate
    |> build_query_options(bucket.id)
    |> Core.list_articles()
    |> Enum.map(fn token ->
      Inspector.inspect(
        "#{token.id}",
        "Potential duplicate article  ID"
      )

      token
    end)
    |> Enum.chunk_every(Network.capacity())
    |> Enum.reduce_while(nil, fn chunk, acc ->
      process_chunk(chunk, candidate.tokens)
      |> case do
        nil -> {:cont, acc}
        id -> {:halt, id} |> Inspector.inspect("Duplication match")
      end
    end)
  end

  defp process_chunk(chunk, tokens) do
    chunk
    |> Enum.zip(Network.available_agents() |> Inspector.inspect("Connected agents"))
    |> Enum.map(&distribute_task(&1, tokens))
    |> Enum.map(&Task.await(&1))
    |> Enum.map(&decompose_match(&1))
    |> List.first()
  end

  defp distribute_task({original_token, agent_node}, tokens) do
    Task.Supervisor.async({Pulitzer.TaskSupervisor, agent_node}, Pulitzer.Core.Scanner, :scan, [
      original_token,
      tokens
    ])
  end

  defp build_query_options(candidate, bucket_id) do
    [
      bucket_id: bucket_id,
      min_words: candidate.words_count - words_offset(candidate.words_count),
      max_words: candidate.words_count + words_offset(candidate.words_count),
      keywords: candidate.keywords
    ]
    |> Inspector.inspect("Query options")
  end

  defp words_offset(count) do
    offset =
      ((100 - @max_duplication_level) / 100)
      |> abs()
      |> Float.round(2)

    round(offset * count)
  end

  def scan(original_token, candiate_token) do
    Network.me() |> Inspector.inspect("#{Time.utc_now()} =======================>")
    original_token.id |> Inspector.inspect("Scanning potential originals")

    duplication_level = Core.detect_duplications(original_token.tokens, candiate_token)
    result = duplication_level >= @max_duplication_level

    {result, original_token}
  end

  defp decompose_match({true, original_id}), do: original_id
  defp decompose_match(_), do: nil
end
