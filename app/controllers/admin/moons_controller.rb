class Admin::MoonsController < Admin::BaseController
  require 'csv'

  skip_before_action :require_login
  skip_before_action :check_admin
  layout 'admin/layouts/application'

  def index
    @moons = Moon.all.preload(:zodiac_sign).order(newmoon_time: :asc)
  end

  def new
    @moon = Moon.new
  end

  def create
    @moon = Moon.new(moon_params)
    if @moon.save
      redirect_to admin_moons_path, notice: t('defaults.message.created', item: Moon.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_created', item: Moon.model_name.human)
      render :new
    end
  end

  def edit
    set_moon
  end

  def update
    set_moon
    if @moon.update(moon_params)
      redirect_to admin_moons_path, notice: t('defaults.message.updated', item: Moon.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_updated', item: Moon.model_name.human)
      render :edit
    end
  end

  def destroy
    set_moon
    @moon.destroy!
    redirect_to admin_moons_path, notice: t('defaults.message.deleted', item: Moon.model_name.human)
  end

  def import
    if Moon.import(params[:moon][:file])
      redirect_to admin_moons_path, notice: t('defaults.message.created', item: Moon.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_created', item: Moon.model_name.human)
      render :new
    end
  end

  private

  def set_moon
    @moon = Moon.find(params[:id])
  end

  def moon_params
    params.require(:moon).permit(:zodiac_sign_id, :newmoon_time, :fullmoon_time)
  end
end
