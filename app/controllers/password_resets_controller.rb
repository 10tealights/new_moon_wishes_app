class PasswordResetsController < ApplicationController
  def create
    @user = User.find_by_email(params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to root_path, notice: t('.reset_success')
  end

  def edit; end

  def update; end
end
