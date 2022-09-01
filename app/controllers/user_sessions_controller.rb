class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = login(params[:account_id], params[:password])

    if @user
      redirect_back_or_to(login_path, notice: t('.login_success'))
    else
      flash[:alert] = t('.login_failed')
      render :new
    end
  end
end
