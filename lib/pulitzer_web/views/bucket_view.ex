defmodule PulitzerWeb.BucketView do
  use PulitzerWeb, :view
  alias PulitzerWeb.BucketView

  def render("show.json", %{bucket: bucket}) do
    render_one(bucket, BucketView, "bucket.json")
  end

  def render("bucket.json", %{bucket: bucket}) do
    %{
      identifier: bucket.identifier
    }
  end
end
