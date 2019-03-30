defmodule FrontendWeb.PageController do
  use FrontendWeb, :controller

  alias Db.Site.Service, as: Site
  alias Db.Category.Service, as: Category
  alias Db.Article.Service, as: Article

  def index(conn, _params) do
    sites = Site.lists(["active", "selected"])
    selected_site_ids = get_selected_site_ids(sites)
    categories = Category.lists()
    articles = Article.lists(selected_site_ids)

    render(conn, "index.html", sites: sites, categories: categories, articles: articles)
  end

  defp get_selected_site_ids(sites) do
    sites
    #|> Enum.filter(fn site -> site.state == "selected" end)
    |> Enum.map(fn site -> site.id end)
  end
end
