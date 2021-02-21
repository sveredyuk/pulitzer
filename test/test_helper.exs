ExUnit.configure(timeout: :infinity)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Pulitzer.Repo, :manual)
