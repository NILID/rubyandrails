class ArticlesController < ApplicationController
  load_and_authorize_resource

  def index
    @articles = @articles.published.order(created_at: :desc)
  end

  def unpublished
    @articles = @articles.unpublished.order(created_at: :desc)
    render :index
  end

  def deleted
    @articles = @articles.deleted.order(created_at: :desc)
    render :index
  end

  def show;  end
  def new;   end
  def edit;  end

  def publish
    status = (@article.has_status? :published) ? 1 : 2
    respond_to do |format|
      if @article.update_attribute(:statuses_mask, status)
        format.html { redirect_to @article, notice: t('flash.was_publish', model_name: Article.model_name.human) }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @article.user = current_user if user_signed_in?

    respond_to do |format|
      if (user_signed_in? || verify_recaptcha(model: @article)) && @article.save
        format.html { redirect_to @article, notice: t('flash.was_created', model_name: Article.model_name.human) }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: t('flash.was_updated', model_name: Article.model_name.human) }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: t('flash.was_deleted', model_name: Article.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :content, :user_id, :mini, { urls_attributes: %i[id title url _destroy] })
    end
end
