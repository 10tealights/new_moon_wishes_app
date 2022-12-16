class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top guide terms privacy]

  def top; end

  def menu; end

  def guide; end

  def terms; end

  def privacy; end
end
