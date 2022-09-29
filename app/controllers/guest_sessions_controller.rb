class GuestSessionsController < ApplicationController
  def create
    @guest_user = User.guest_generate
    auto_login(@guest_user)

    redirect_to new_wish_path
  end
end
