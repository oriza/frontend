defmodule FrontendWeb.LayoutView do
  use FrontendWeb, :view

  defdelegate calendar(datetime), to: Frontend.Helpers.DateTime, as: :calendar
end
