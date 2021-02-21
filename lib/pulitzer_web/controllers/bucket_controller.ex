defmodule PulitzerWeb.BucketController do
  use PulitzerWeb, :controller

  alias Pulitzer.Core
  alias Pulitzer.Core.Bucket

  action_fallback PulitzerWeb.FallbackController

  def create(conn, %{"identifier" => identifier}) do
    with {:ok, %Bucket{} = bucket} <- Core.create_bucket(identifier) do
      conn
      |> put_status(:created)
      |> render("show.json", bucket: bucket)
    end
  end
end
