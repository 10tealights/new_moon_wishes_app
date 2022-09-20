class DeclarationsController < ApplicationController
  def index
    @wishes = current_user.wishes.order(id: :desc).preload(declarations: :tags).preload(:zodiac_sign)
  end

  def new
    @form = Form::DeclarationCollection.new
  end

  def create
    @form = Form::DeclarationCollection.new(current_user, declaration_collection_params)
    if @form.save
      redirect_to new_declaration_path, notice: t('.created')
    else
      flash[:alert] = t('.not_created')
      render :new
    end
  end

  private

  def declaration_collection_params
    params
      .require(:form_declaration_collection)
      .permit(declarations_attributes: [:message, :is_shared, { declaration_tags: [] }])
  end
end
