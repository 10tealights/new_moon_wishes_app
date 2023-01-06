require 'rails_helper'

RSpec.describe 'Wishes', type: :request do
  let(:user) { build(:user) }

  describe 'GET /wishes/new' do
    it '願いごと宣言画面が正常に表示されること' do
      user_create_and_login(user)
      get new_wish_path
      expect(response.body).to include('願いごとを宣言しましょう(2~10個)')
      expect(response.status).to eq 200
    end

    it '未ログインの場合はTOPページにリダイレクトされること' do
      get new_wish_path
      expect(response).to redirect_to login_path
    end
  end

  describe 'POST /wishes' do
    let(:current_user) { build(:user) }
    let(:declaration) { build(:declaration) }

    it '願いごと登録処理が正常に実行されること' do
      user_create_and_login(current_user)
      declarations = build_list(:declaration, 2)
      expect {
        post wishes_path, params: { wish: { declarations_attributes: { '0': {is_shared: declarations[0].is_shared, message: declarations[0].message, declaration_tags: { tag_id: '1'}}, '1': {is_shared: declarations[1].is_shared, message: declarations[1].message, declaration_tags: { tag_id: ['1', '2'] }}}}}
      }.to change(Wish, :count).by(1)
      expect(response).to redirect_to wishes_path
    end

    it '願いごとが1個のみの場合に登録処理が失敗すること' do
      user_create_and_login(current_user)
      expect {
        post wishes_path, params: { wish: { declarations_attributes: { '0': {is_shared: 'true', message: 'test', declaration_tags: { tag_id: '10'}}}}}
      }.to change(Wish, :count).by(0)
      expect(response.body).to include('願いごとは2〜10個で宣言してください')
      expect(response.status).to eq 200
    end

    it '願いごとのメッセージ本文が100文字を超えている場合に登録処理が失敗すること' do
      user_create_and_login(current_user)
      declarations = build_list(:declaration, 2)
      expect {
        post wishes_path, params: { wish: { declarations_attributes: { '0': {is_shared: declarations[0].is_shared, message: declarations[0].message, declaration_tags: { tag_id: '1'}}, '1': {is_shared: declarations[1].is_shared, message: 'a'*101, declaration_tags: { tag_id: ['1', '2'] }}}}}
      }.to change(Wish, :count).by(0)
      expect(response.body).to include('メッセージは100文字以内で入力してください')
      expect(response.body).to include('a'*101)
    end
  end

  describe 'GET /wishes' do
    it '願いごと一覧画面が正常に表示されること' do
      user_create_and_login(user)
      get wishes_path
      expect(response.body).to include('宣言した願いごと')
      expect(response.status).to eq 200
    end

    it '未ログインの場合はTOPページにリダイレクトされること' do
      get wishes_path
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET /wishes/:id/edit' do
    let!(:first_declaration) { create(:declaration, :add_wish) }
    let!(:second_declaration) { create(:declaration, wish_id: first_declaration.wish_id)}

    it '願いごと編集画面が正常に表示されること' do
      login(first_declaration.wish.user)
      get edit_wish_path(first_declaration.wish)
      expect(response.body).to include('宣言した内容のみ編集できます(願いごとは増やせません)')
      expect(response.body).to include(first_declaration.message)
      expect(response.body).to include(second_declaration.message)
      expect(response.status).to eq 200
    end

    it '未ログインの場合はTOPページにリダイレクトされること' do
      get edit_wish_path(first_declaration.wish)
      expect(response).to redirect_to login_path
    end
  end

  describe 'PATCH /wishes/:id' do
    let(:first_declaration) { create(:declaration, :add_wish) }
    let(:second_declaration) { create(:declaration, wish_id: first_declaration.wish_id) }

    it '願いごと更新処理が正常に実行されること' do
      login(first_declaration.wish.user)
      patch wish_path(first_declaration.wish), params: { wish: { declarations_attributes: { '0': {is_shared: 'false', message: 'updated_message_0', declaration_tags: { tag_id: '2'}, id: first_declaration.id }, '1': {is_shared: 'false', message: 'updated_message_1', declaration_tags: { tag_id: ['3', '4'] }, id: second_declaration.id }}}, id: first_declaration.wish_id }
      expect(response).to redirect_to wishes_path
    end

    it '願いごとを1個のみに編集した場合に更新処理が失敗すること' do
      login(first_declaration.wish.user)
      patch wish_path(first_declaration.wish), params: { wish: { declarations_attributes: { '0': {is_shared: 'false', message: 'updated_message_0', declaration_tags: { tag_id: '2'}, id: first_declaration.id }, '1': {is_shared: 'false', message: '', declaration_tags: { tag_id: nil }, id: second_declaration.id }}}, id: first_declaration.wish_id }
      expect(response.body).to include('願いごとは2〜10個で宣言してください')
      expect(response.status).to eq 200
    end

    it '願いごとのメッセージ本文が100文字を超えている場合に更新処理が失敗すること' do
      login(first_declaration.wish.user)
      patch wish_path(first_declaration.wish), params: { wish: { declarations_attributes: { '0': {is_shared: 'false', message: 'updated_message_0', declaration_tags: { tag_id: '2'}, id: first_declaration.id }, '1': {is_shared: 'false', message: 'a'*101, declaration_tags: { tag_id: ['3', '4'] }, id: second_declaration.id }}}, id: first_declaration.wish_id }
      expect(response.body).to include('メッセージは100文字以内で入力してください')
      expect(response.status).to eq 200
    end
  end

  describe 'DELETE /wishes/:id' do
    let!(:first_declaration) { create(:declaration, :add_wish) }
    let!(:second_declaration) { create(:declaration, wish_id: first_declaration.wish_id) }

    it '願いごとが正常に削除処理されること' do
      login(first_declaration.wish.user)
      expect {
        delete wish_path(first_declaration.wish)
      }.to change(Wish, :count).by(-1)
      expect(response).to redirect_to wishes_path
    end
  end
end
