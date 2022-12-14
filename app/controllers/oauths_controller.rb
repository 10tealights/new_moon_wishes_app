class OauthsController < ApplicationController
  skip_before_action :require_login, only: %i[oauth callback]

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:error].present?
      redirect_to root_path, notice: 'ログイン(連携)をキャンセルしました' 
      return
    end

    if @user = login_from(provider)
      redirect_to menu_path, notice:(t'.login_success', item: provider.upcase)
    else
      begin
        @user = current_user.present? ? update_from(provider) : create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to menu_path, notice: (t'.login_success', item: provider.upcase)
      rescue
        redirect_to root_path, notice: (t'.login_failed', item: provider.upcase)
      end
    end
  end

  def destroy
    @oauth = current_user.authentications.find(params[:id])
    @oauth.destroy!
    current_user.update!(line_name: nil, picture_url: nil, need_newmoon_msg: false, need_fullmoon_msg: false)
    redirect_to profile_path, notice: t('.destroyed')
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end

  # Rails7で追加されたOpen Redirect protectionを無効化するためSorceryのメソッドをオーバーライド
  def login_at(provider_name, args = {})
    redirect_to sorcery_login_url(provider_name, args), allow_other_host: true
  end

  # すでにログイン中ユーザーがいる場合は既存のデータにLINE情報を紐づけ、UserモデルにLINEの情報を追加更新する
  def update_from(provider_name, &block)
    sorcery_fetch_user_hash provider_name
    attrs = user_attrs(@provider.user_info_mapping, @user_hash)
    current_user.update(attrs.except(:name))
    current_user.add_provider_to_user(provider_name.to_s, @user_hash[:uid].to_s)
    current_user
  end
end
