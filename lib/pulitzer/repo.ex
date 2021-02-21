defmodule Pulitzer.Repo do
  use Ecto.Repo,
    otp_app: :pulitzer,
    adapter: Ecto.Adapters.Postgres

  def fetch(nil) do
    {:error, :not_found}
  end

  def fetch(record) do
    {:ok, record}
  end
end
