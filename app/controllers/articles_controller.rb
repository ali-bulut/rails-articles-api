class ArticlesController < ApplicationController
  include Paginable

  skip_before_action :authorize!, only: [:index, :show]

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  # rescue ActiveRecord::RecordNotFound => e
  #   render json: { message: e.message, detail: "Formatted response" }
  end

  def serializer
    # rails g serializer article title content slug => it'll create ArticleSerializer in app/serializers
    ArticleSerializer
  end
end