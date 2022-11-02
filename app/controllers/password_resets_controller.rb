class PasswordResetsController < ApplicationController
  def create
    @user = User.find_by_email(params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to root_path, notice: t('.reset_success')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    not_authenticated if @user.blank?
  end

  # rubocop:disable Metrics/AbcSize
  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to login_path, notice: t('.change_success')
    else
      flash.now[:alert] = t('.change_failed')
      render :edit
    end
  end
  # rubocop:enable Metrics/AbcSize
end
