class Admin::DashboardsController < Admin::BaseController
  skip_before_action :require_login
  skip_before_action :check_admin

  def index; end

end
