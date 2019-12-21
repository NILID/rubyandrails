class VideosController < ApplicationController
  load_and_authorize_resource except: [:youtube_title]

  def index
    @videos = @videos.order('created_at DESC')
    @title = I18n.t('videos.title')
  end

  def show
    @video.update_views
  end

  def new
  end

  def edit
  end

  def like
    current_user.toggle_like!(@video)
    respond_to do |format|
      format.js
    end
  end

  def create
    @video = Video.new(video_params)
    @video.user = current_user if current_user

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: t('was_created.video') }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: t('was_updated.video') }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: t('was_destroyed.video') }
      format.json { head :no_content }
    end
  end

  def youtube_title
    video = VideoInfo.new(params[:url])
    respond_to do |format|
      format.json { render json: { result: video.title } }
    end
  end

  private
    def video_params
      params.require(:video).permit(
        :title,
        :url,
        :user_id
      )
    end
end
