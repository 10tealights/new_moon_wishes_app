class AffirmationsController < ApplicationController
  def show
    @wish = current_user.wishes.find(params[:id])
  end
end
