class MainController < ApplicationController
  def index
    @articles = Article.published.order(created_at: :desc)
  end
end
