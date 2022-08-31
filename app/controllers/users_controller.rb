class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_path, notice: 'ユーザー登録が完了しました'
    else
      flash[:alert] = 'ユーザー登録ができませんでした'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :account_id, :password, :password_confirmation)
  end
end
