class WishesController < ApplicationController
  def index
    @wishes = current_user.wishes.order(id: :desc).preload(declarations: :tags).preload(:zodiac_sign)
  end

  def new
    @form = Form::DeclarationCollection.new
  end

  def create
    @form = Form::DeclarationCollection.new(current_user, declaration_collection_params)
    if @form.save
      redirect_to wishes_path, notice: t('.created')
    else
      flash[:alert] = t('.not_created')
      render :new
    end
  end

  def edit
    @form = Form::DeclarationCollection.new(wish: current_user.wishes.find(params[:id]))
  end

  def update
    @form = Form::DeclarationCollection.new(current_user, declaration_collection_params, wish: current_user.wishes.find(params[:id]))
    if @form.update(tag_params)
      redirect_to wishes_path, notice: t('.created')
    else
      flash[:alert] = t('.not_created')
      render :edit
    end
  end

  private

  def declaration_collection_params
    params
      .require(:form_declaration_collection)
      .permit(:id, declarations_attributes: [:id, :message, :is_shared, { declaration_tags: [{ tag_id: [] }] }])
  end

  def tag_params
    params
      .require(:form_declaration_collection)
      .permit(declarations_attributes: [declaration_tags: [:id, { tag_id: [] }]])[:declarations_attributes]
  end
end
