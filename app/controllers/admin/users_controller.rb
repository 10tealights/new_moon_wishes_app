class Admin::UsersController < Admin::BaseController
  skip_before_action :require_login
  skip_before_action :check_admin
  layout 'admin/layouts/application'

  def index
    @users = User.all.preload(:authentications).order(created_at: :desc)
  end

  def edit
    set_user
    @authentication = @user.authentications
  end

  def update
    set_user
    if @user.update(user_params)
      redirect_to admin_users_path, notice: t('defaults.message.updated', item: User.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_updated', item: User.model_name.human)
      render :edit
    end
  end

  def destroy
    set_user
    @user.destroy!
    redirect_to admin_users_path, notice: t('.destroyed')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :need_newmoon_msg, :need_fullmoon_msg, :role)
  end
end
