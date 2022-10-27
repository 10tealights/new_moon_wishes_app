class CheersController < ApplicationController
  def index
    @latest_moon = Moon.latest
    @moon_sign = @latest_moon.zodiac_sign
    @other_wished_declarations = Declaration.eager_load([{ wish: :zodiac_sign }, { wish: :user }, :tags, :cheers]).shared_other_declarations(current_user, 'wished')
    @other_fulfilled_declarations = Declaration.eager_load([{ wish: :zodiac_sign }, { wish: :user }, :tags, :cheers]).shared_other_declarations(current_user, 'fulfilled')
  end

  def create
    @cheered_declaration = Declaration.find(params[:other_declaration_id])
    current_user.cheered_declarations << @cheered_declaration
    redirect_back fallback_location: cheers_path, notice: t('.created')
  end
end
