class ProfilesController < ApplicationController
  def show
    set_current_user
  end

  def edit
    set_current_user
  end

  private

  def set_current_user
    @current_user = User.find(current_user.id)
  end
end
