class AffirmationsController < ApplicationController
  layout 'affirmation'

  def show
    @wish = current_user.wishes.find(params[:id])
  end
end
