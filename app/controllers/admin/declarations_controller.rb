class Admin::DeclarationsController < Admin::BaseController
  def index
    @declarations = Declaration.where(is_shared: 'true').preload([{ wish: :zodiac_sign }, { wish: :user }]).order(created_at: :desc)
  end

  def destroy
    @declaration = Declaration.find(params[:id])
    @declaration.destroy!
    redirect_to admin_declarations_path, notice: t('defaults.message.deleted', item: Declaration.model_name.human)
  end
end
