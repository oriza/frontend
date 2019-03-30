defmodule FrontendWeb.PageView do
  use FrontendWeb, :view
  use Timex

  def truncate(text, _) when is_nil(text), do: ""
  def truncate(text, text_length \\ 225) do
    if String.length(text) <= text_length do
      text
    else
      String.slice(text, 0..text_length) <> "..."
    end
  end

  def format_datetime(nil), do: ""
  def format_datetime(datetime) do
    tz = Timezone.get("Europe/Budapest", Timex.now)
    now = DateTime.utc_now() |> Timezone.convert(tz)
    dt = datetime |> Timezone.convert(tz)

    cond do
      Timex.diff(now, dt, :months) > 0 ->
        "#{dt.year}. #{get_month(dt.month)} #{format_day(dt.day)}."
      Timex.diff(now, dt, :days) > 0 ->
        "#{dt.month} #{format_day(dt.day)}."
      Timex.diff(now, dt, :hours) > 0 ->
        datetime |> Timex.format!("%H:%M", :strftime)
      Timex.diff(now, dt, :minutes) > 0 ->
        "#{Timex.diff(now, dt, :minutes)} perce"
      Timex.diff(now, dt, :seconds) > 0 ->
        "#{Timex.diff(now, dt, :seconds)} másodperce"
      true ->
        datetime
    end
  end

  defp get_month(1), do: "január"
  defp get_month(2), do: "február"
  defp get_month(3), do: "március"
  defp get_month(4), do: "április"
  defp get_month(5), do: "május"
  defp get_month(6), do: "június"
  defp get_month(7), do: "július"
  defp get_month(8), do: "augusztus"
  defp get_month(9), do: "szeptember"
  defp get_month(10), do: "október"
  defp get_month(11), do: "november"
  defp get_month(12), do: "december"
  defp get_month(_), do: ""

  defp format_day(1), do: "01"
  defp format_day(2), do: "02"
  defp format_day(3), do: "03"
  defp format_day(4), do: "04"
  defp format_day(5), do: "05"
  defp format_day(6), do: "06"
  defp format_day(7), do: "07"
  defp format_day(8), do: "08"
  defp format_day(9), do: "09"
  defp format_day(num), do: Integer.to_string(num)
end
