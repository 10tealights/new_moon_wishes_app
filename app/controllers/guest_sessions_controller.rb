class GuestSessionsController < ApplicationController
  skip_before_action :require_login

  def create
    @guest_user = User.guest_generate
    auto_login(@guest_user)

    redirect_to new_wish_path, notice: t('.created')
  end
end
