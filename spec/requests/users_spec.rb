require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/new' do
    it 'ユーザー新規登録画面の表示に成功すること' do
      get new_user_path
      expect(response.status).to eq 200
    end
  end

  describe 'POST /users' do
    let(:user) { build(:user) }

    it '正しい入力ではユーザー新規登録処理に成功すること' do
      expect {
        post users_path, params: { user: { name: user.name, email: user.email, password: user.password, password_confirmation: user.password_confirmation } }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to menu_path
    end

    it '既存のユーザーでは登録処理に失敗すること' do
      user.save
      post users_path, params: { user: { name: user.name, email: user.email, password: user.password, password_confirmation: user.password_confirmation } }
      expect(response.status).to eq 200
      expect(response.body).to include 'メールアドレスはすでに存在します'
    end

    it 'メールアドレス不足では登録処理に失敗すること' do
      post users_path, params: { user: { name: user.name, email: nil, password: user.password, password_confirmation: user.password_confirmation } }
      expect(response.status).to eq 200
      expect(response.body).to include 'メールアドレスを入力してください'
    end

    it 'メールアドレスの形式が不適切では登録処理に失敗すること' do
      post users_path, params: { user: { name: user.name, email: 'userexample.com', password: user.password, password_confirmation: user.password_confirmation } }
      expect(response.status).to eq 200
      expect(response.body).to include 'メールアドレスは不正な値です'
    end

    it 'パスワード不足では登録処理に失敗すること' do
      post users_path, params: { user: { name: user.name, email: user.email, password: nil, password_confirmation: nil } }
      expect(response.status).to eq 200
      expect(response.body).to include 'パスワードは7文字以上で入力してください'
      expect(response.body).to include 'パスワード(確認)を入力してください'
    end

    it 'パスワード(確認用)不足では登録処理に失敗すること' do
      post users_path, params: { user: { name: user.name, email: user.email, password: user.password, password_confirmation: nil } }
      expect(response.status).to eq 200
      expect(response.body).to include 'パスワード(確認)を入力してください'
    end

    it 'パスワードの条件が満たされない状態では登録処理に失敗すること' do
      post users_path, params: { user: { name: user.name, email: user.email, password: 'pass', password_confirmation: 'pass' } }
      expect(response.status).to eq 200
      expect(response.body).to include 'パスワードは7文字以上で入力してください'
    end
  end

  describe 'DELETE /users/:id' do
    let!(:current_user) { create(:user) }

    before do
      auth_stub
    end

    it 'ユーザーの削除処理に成功すること' do
      expect {
        delete user_path(current_user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to root_path
    end
  end
end
