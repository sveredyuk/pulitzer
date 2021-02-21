defmodule PulitzerWeb.ErrorView do
  use PulitzerWeb, :view

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Not found"}}
  end

  def render("400.json", _assigns) do
    %{errors: %{detail: "Bad request"}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
