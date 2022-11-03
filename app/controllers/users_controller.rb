class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to menu_path, notice: t('defaults.message.created', item: User.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_created', item: User.model_name.human)
      render :new
    end
  end

  def edit
    @user = current_user
    @user.assign_attributes(name: '', email: '')
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to profile_path, notice: t('defaults.message.created', item: User.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_created', item: User.model_name.human)
      render :edit
    end
  end

  def destroy
    @current_user = User.find(current_user.id)
    @current_user.destroy!
    redirect_to root_path, notice: t('.destroyed')
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
