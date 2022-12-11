class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login
  skip_before_action :check_admin
  layout 'admin/layouts/admin_login'

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to admin_root_path, notice: t('.login_success')
    else
      flash.now[:alert] = t('.login_failed')
      render :new
    end
  end

  def destroy
    logout
    redirect_to admin_login_path, notice: t('.logout_success')
  end
end
