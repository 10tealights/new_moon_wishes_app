class Admin::TraitsController < Admin::BaseController
  def index
    @traits = Trait.all.preload(:zodiac_sign).order(zodiac_sign_id: :asc)
  end

  def new
    @trait = Trait.new
  end

  def create
    @trait = Trait.new(trait_params)
    if @trait.save
      redirect_to admin_traits_path, notice: t('defaults.message.created', item: Trait.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_created', item: Trait.model_name.human)
      render :new
    end
  end

  def edit
    set_trait
  end

  def update
    set_trait
    if @trait.update(trait_params)
      redirect_to admin_traits_path, notice: t('defaults.message.updated', item: Trait.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_updated', item: Trait.model_name.human)
      render :edit
    end
  end

  def destroy
    set_trait
    @trait.destroy!
    redirect_to admin_traits_path, notice: t('defaults.message.deleted', item: Trait.model_name.human)
  end

  private

  def set_trait
    @trait = Trait.find(params[:id])
  end

  def trait_params
    params.require(:trait).permit(:zodiac_sign_id, :keyword)
  end
end
