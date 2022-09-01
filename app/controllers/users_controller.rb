class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: t('defaults.message.created', item: User.model_name.human)
    else
      flash[:alert] = t('defaults.message.not_created', item: User.model_name.human)
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :account_id, :password, :password_confirmation)
  end
end
