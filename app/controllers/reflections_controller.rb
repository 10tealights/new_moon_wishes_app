class ReflectionsController < ApplicationController
  def edit
    set_wish
    @form = Form::DeclarationCollection.new(current_user, wish: @wish)
  end

  def update
    set_wish
    @form = Form::DeclarationCollection.new(current_user, wish_params, wish: @wish)
    if @form.update(wish_params)
      redirect_to wishes_path, notice: t('.updated')
    else
      flash[:alert] = t('.not_updated')
      render :edit
    end
  end

  private

  def set_wish
    @wish = current_user.wishes.find(params[:id])
  end

  def wish_params
    params
      .require(:wish)
      .permit(:id, :memo, declarations_attributes: %i[id is_shared come_true])
  end
end
