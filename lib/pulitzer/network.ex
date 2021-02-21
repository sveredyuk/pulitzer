defmodule Pulitzer.Network do
  alias Pulitzer.Inspector

  def connect do
    if main_node() do
      main_node()
      |> String.to_atom()
      |> Inspector.inspect("Connecting to the main node")
      |> Node.connect()
    else
      false
    end
  end

  defp main_node, do: System.get_env("PULITZER_MAIN_NODE")

  def me do
    Node.self()
  end

  def available_agents do
    Node.list()
    |> case do
      [] -> [me()]
      agents -> agents
    end
    |> Enum.shuffle()
  end

  def capacity do
    1 + Enum.count(Node.list())
  end
end
