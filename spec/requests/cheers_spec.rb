require 'rails_helper'

RSpec.describe 'Cheers', type: :request do
  let(:current_user) { build(:user) }

  describe "GET /cheers" do
    it '願いごと応援画面が正常に表示されること' do
      user_create_and_login(current_user)
      get cheers_path
      expect(response.body).to include('CHEER DECLARATIONS')
      expect(response.status).to eq 200
    end
  end

  describe "POST /cheers" do
    let!(:declaration) { create(:declaration, :add_wish) }

    it '願いごと応援機能が正常に処理されること' do
      user_create_and_login(current_user)
      expect {
        post cheers_path, params: { other_declaration_id: declaration.id }
      }.to change(Cheer, :count).by(1)
      expect(response).to redirect_to cheers_path
    end
  end
end
