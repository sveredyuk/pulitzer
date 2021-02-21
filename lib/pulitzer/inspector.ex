defmodule Pulitzer.Inspector do
  @default_label "PULITZER INSPECTOR"

  def inspect(input, label \\ @default_label) do
    if enabled?() do
      # credo:disable-for-next-line
      IO.inspect(input, label: label)
    else
      input
    end
  end

  defp enabled?, do: System.get_env("PULITZER_ENABLE_INSPECTOR") == "1"
end
