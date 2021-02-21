defmodule Pulitzer.Core.Detector do
  alias Pulitzer.Inspector

  def detect_duplications(original_tokens_list, candidate_tokens_list) do
    original_tokens_list
    |> evaluate_difference(candidate_tokens_list)
    |> evaluate_duplication_level(Enum.count(original_tokens_list))
    |> Float.round(2)
    |> Inspector.inspect("Duplication detection result")
  end

  # I decided to not reinvent a bicycle and use the exiting
  # Myers diff algorithm function as part of the Elixir Kernel <3
  # More info: https://en.wikipedia.org/wiki/Diff
  # Elixir docs:  https://hexdocs.pm/elixir/List.html#myers_difference/2
  # Source code: https://github.com/elixir-lang/elixir/blob/v1.11.1/lib/elixir/lib/list.ex#L1026
  defp evaluate_difference(original, candidate) do
    List.myers_difference(original, candidate)
    |> Inspector.inspect("Diff changes")
    |> Enum.reduce(%{eq: 0, del: 0, ins: 0}, fn {diff_key, words}, acum ->
      Map.update(acum, diff_key, 1, &(&1 + Enum.count(words)))
    end)
    |> Inspector.inspect("Diff count")
  end

  def evaluate_duplication_level(
        %{eq: eq_count, del: del_count, ins: ins_count},
        original_tokens_count
      ) do
    (eq_count + del_count - ins_count) / original_tokens_count * 100
  end
end
