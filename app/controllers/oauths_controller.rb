class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice:(t'.login_success', item: provider.titleize)
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, notice: (t'.login_success', item: provider.titleize)
      rescue
        redirect_to root_path, alert: (t'.login_failed', item: provider.titleize)
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end

  # Rails7で追加されたOpen Redirect protectionを無効化するためSorceryのメソッドをオーバーライド
  def login_at(provider_name, args = {})
    redirect_to sorcery_login_url(provider_name, args), allow_other_host: true
  end
end
