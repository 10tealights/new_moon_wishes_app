class Admin::BaseController < ApplicationController
  before_action :check_admin
  layout 'admin/layouts/application'

  private

  def not_authenticated
    redirect_to admin_login_url, notice: t('defaults.message.not_authenticated')
  end

  def check_admin
    redirect_to root_path, notice: t('defaults.message.not_authorized') unless current_user.admin?
  end
end
