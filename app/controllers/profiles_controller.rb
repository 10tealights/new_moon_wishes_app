class ProfilesController < ApplicationController
  def show
    set_current_user
    @oauth = current_user.authentications.find_by(provider: 'line')
  end

  def edit
    set_current_user
  end

  def update
    set_current_user
    if @current_user.update(profile_params)
      redirect_to profile_path, notice: t('defaults.message.updated', item: 'プロフィール')
    else
      flash.now[:alert] = t('defaults.message.not_updated', item: 'プロフィール')
      render :edit
    end
  end

  private

  def set_current_user
    @current_user = User.find(current_user.id)
  end

  def profile_params
    params.require(:user).permit(:name, :email)
  end
end
