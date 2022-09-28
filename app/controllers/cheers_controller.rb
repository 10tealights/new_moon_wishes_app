class CheersController < ApplicationController
  def index
    @latest_moon = Moon.latest
    @moon_sign = @latest_moon.zodiac_sign
    @other_declarations = Declaration.eager_load([{ wish: :zodiac_sign }, { wish: :user }, :tags, :cheers]).order(updated_at: :desc).where.not(user: { id: current_user.id }).where.not(come_true: 'removed').where(is_shared: 'true')
  end

  def create
    @cheered_declaration = Declaration.find(params[:declaration_id])
    current_user.cheered_declarations << @cheered_declaration
    redirect_back fallback_location: cheers_path, notice: t('.created')
  end
end
