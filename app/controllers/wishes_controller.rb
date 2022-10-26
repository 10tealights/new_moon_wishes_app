class WishesController < ApplicationController
  def index
    @wishes = current_user.wishes.order(id: :desc).preload(declarations: :tags).preload(:zodiac_sign)
  end

  def new
    @latest_newmoon = Moon.latest
    @keywords = Trait.where(zodiac_sign_id: @latest_newmoon.zodiac_sign_id).map(&:keyword).shuffle
    @form = Form::DeclarationCollection.new(wish: current_user.wishes.build)
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

  def destroy
    @wish = current_user.wishes.find(params[:id])
    @wish.destroy
    redirect_to wishes_path, notice: t('.destroyed')
  end

  private

  def declaration_collection_params
    params
      .require(:wish)
      .permit(:id, declarations_attributes: [:id, :message, :is_shared, { declaration_tags: [{ tag_id: [] }] }])
  end

  def tag_params
    params
      .require(:wish)
      .permit(declarations_attributes: [declaration_tags: [:id, { tag_id: [] }]])[:declarations_attributes]
  end
end
