defmodule Frontend.Helpers.DateTime do

  use Timex

  def calendar(datetime) do
    [month, day] = String.split(datetime, "/")

    formatted_month = month
    |> String.to_integer
    |> get_month

    "#{formatted_month} #{day}."
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

  def get_month(1), do: "január"
  def get_month(2), do: "február"
  def get_month(3), do: "március"
  def get_month(4), do: "április"
  def get_month(5), do: "május"
  def get_month(6), do: "június"
  def get_month(7), do: "július"
  def get_month(8), do: "augusztus"
  def get_month(9), do: "szeptember"
  def get_month(10), do: "október"
  def get_month(11), do: "november"
  def get_month(12), do: "december"
  def get_month(_), do: ""

  def format_day(1), do: "01"
  def format_day(2), do: "02"
  def format_day(3), do: "03"
  def format_day(4), do: "04"
  def format_day(5), do: "05"
  def format_day(6), do: "06"
  def format_day(7), do: "07"
  def format_day(8), do: "08"
  def format_day(9), do: "09"
  def format_day(num), do: Integer.to_string(num)
end
