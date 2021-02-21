defmodule Pulitzer.AsycProcess do
  def run(list, fun) when is_list(list) do
    list
    |> Task.async_stream(fun)
    |> aggregate_result()
  end

  defp aggregate_result(task_result) do
    Enum.map(task_result, fn {:ok, result} -> result end)
  end
end
