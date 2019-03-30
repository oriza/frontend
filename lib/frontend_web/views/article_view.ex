defmodule FrontendWeb.ArticleView do
  use FrontendWeb, :view

  def render("index.json", %{articles: articles}) do
    %{articles: render_many(articles, FrontendWeb.ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{
      id: article.id,
      title: article.title,
      description: article.description,
      published_at: article.published_at,
      site: %{
        name: article.site.name,
        slug: article.site.slug
      },
      url: article.url
    }
  end
end
