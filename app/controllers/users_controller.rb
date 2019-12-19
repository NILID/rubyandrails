class UsersController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      if user_params[:profile_attributes] && user_params[:profile_attributes][:avatar].present?
        render :crop
      else
        redirect_to @user, notice: t('flash.was_updated', model_name: User.model_name.human)
      end
    else
      render action: 'edit'
    end
  end

  private
    def user_params
      list_params_allowed = [
                              { profile_attributes: [
                                :id,
                                :crop_settings,
                                :avatar,
                                :crop_x, :crop_y, :crop_w, :crop_h
                              ] }
                            ]
      list_params_allowed << [:login, roles: []] if current_user.role? :admin
      params.require(:user).permit(list_params_allowed)
    end
end
