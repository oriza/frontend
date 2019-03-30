defmodule FrontendWeb.ArticleController do
  use FrontendWeb, :controller

  alias Db.Article.Service, as: Article

  def index(conn, %{"sites" => sites, "categories" => categories, "till" => till}) do
    site_ids = convert_params_to_list(sites)
    till = datetime_or_fallback(till)

    category_ids = convert_params_to_list(categories)
    articles = Article.lists(site_ids, till)

    render(conn,"index.json", %{articles: articles})
  end

  defp convert_params_to_list(params) when is_binary(params) do
    String.split(params, ",")
  end

  defp convert_params_to_list(_), do: []

  defp datetime_or_fallback(datetime, fallback \\ DateTime.utc_now()) when is_binary(datetime) do
    if String.strip(datetime) == "" do
      fallback
    else
      datetime
    end
  end

  defp datetime_or_fallback(datetime, _fallback), do: datetime
end
