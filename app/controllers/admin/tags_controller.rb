class Admin::TagsController < Admin::BaseController
  skip_before_action :require_login
  skip_before_action :check_admin
  layout 'admin/layouts/application'

  def index
    @tags = Tag.left_joins(:declaration_tags).group(:id).order(Arel.sql('COUNT(declaration_tags.tag_id) desc'))
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path, notice: t('defaults.message.created', item: Tag.model_name.human)
    else
      flash.now[:alert] = t('defaults.message.not_created', item: Tag.model_name.human)
      render :new
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy!
    redirect_to admin_tags_path, notice: t('defaults.message.deleted', item: Tag.model_name.human)
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
