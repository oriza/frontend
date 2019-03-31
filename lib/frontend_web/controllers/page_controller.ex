defmodule FrontendWeb.PageController do
  use FrontendWeb, :controller

  alias Db.Site.Service, as: Site
  alias Db.Category.Service, as: Category
  alias Db.Article.Service, as: Article
  alias Db.Calendar.Service, as: Calendar
  alias Db.Weather.Service, as: Weather

  def index(conn, _params) do
    sites = Site.lists(["active", "selected"])
    categories = Category.lists()
    today = Calendar.today!()
    weather = Weather.get_by!("Budapest")

    selected_site_ids = get_selected_sites(conn, sites)

    articles = Article.lists(selected_site_ids)

    render(conn, "index.html", sites: sites, categories: categories, articles: articles, selected_site_ids: selected_site_ids, today: today, weather: weather)
  end

  defp get_selected_sites(conn, sites) do
    case get_selected_from_cookie(conn) do
      nil ->
        get_selected_from_state(sites)
      cookie_sites ->
        Enum.map(cookie_sites, &id_to_integer/1)
    end
  end

  defp get_selected_from_cookie(conn) do
    case Map.get(conn.cookies, "sites", nil) do
      sites when is_binary(sites) ->
        String.split(sites, ".")
      _ ->
        nil
    end
  end

  defp get_selected_from_state(sites) do
    sites
    |> Enum.filter(fn site -> site.state == "selected" end)
    |> Enum.map(fn site -> site.id end)
  end

  defp id_to_integer(id) do
    if String.strip(id) == "" do
      nil
    else
      String.to_integer(id)
    end
  end
end
