class ArticlesController < ApplicationController
  def index
    articles = Article.all
    render json: serializer.new(articles), status: :ok
  end

  def serializer
    # rails g serializer article title content slug => it'll create ArticleSerializer in app/serializers
    ArticleSerializer
  end
end