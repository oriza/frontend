defmodule FrontendWeb.PageView do
  use FrontendWeb, :view

  def truncate(text, text_length) when is_nil(text), do: ""
  def truncate(text, text_length \\ 225) do
    if String.length(text) <= text_length do
      text
    else
      String.slice(text, 0..text_length) <> "..."
    end
  end

  defdelegate format_datetime(datetime), to: Frontend.Helpers.DateTime, as: :format_datetime
end
