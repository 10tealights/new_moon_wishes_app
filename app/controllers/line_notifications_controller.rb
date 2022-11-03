class LineNotificationsController < ApplicationController
  before_action :require_login

  def update
    current_user.change_notification_status(notification_params)
    redirect_to profile_path, notice: t('.updated')
  end

  private

  def notification_params
    params.permit(:need_newmoon_msg, :need_fullmoon_msg)
  end
end

