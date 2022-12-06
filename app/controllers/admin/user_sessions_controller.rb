class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login
  skip_before_action :check_admin
  layout 'admin/layouts/admin_login'

  def new; end

end
