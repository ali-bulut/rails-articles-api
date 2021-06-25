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

  def create
    article = Article.new(article_params)
    if article.valid?
    else
      render json: article.errors, status: :unprocessable_entity
    end
  end

  private

  def serializer
    # rails g serializer article title content slug => it'll create ArticleSerializer in app/serializers
    ArticleSerializer
  end

  def article_params
    ActionController::Parameters.new
  end
end