class CheersController < ApplicationController
  def index
    @latest_moon = Moon.latest
    @moon_sign = @latest_moon.zodiac_sign
    @other_declarations = Declaration.eager_load(wish: %i[moon user]).eager_load(:tags).where.not(user: { id: current_user.id }).where(is_shared: 'true').where(moon: { id: @latest_moon.id })
  end
end
