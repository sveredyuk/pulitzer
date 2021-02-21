defmodule PulitzerWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: PulitzerWeb

      import Plug.Conn
      import PulitzerWeb.Gettext
      alias PulitzerWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/pulitzer_web/templates",
        namespace: PulitzerWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import PulitzerWeb.ErrorHelpers
      import PulitzerWeb.Gettext
      alias PulitzerWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
