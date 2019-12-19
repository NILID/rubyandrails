require 'rails_helper'

describe ArticlesController do
  let!(:article) { create(:article, :published) }
  let(:author)  { article.user }
  let!(:unpublished_article) { create(:article, user: author) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'publish' do
      expect(@ability.can? :publish, unpublished_article).to be true
      expect{ put :publish, params: { id: unpublished_article } }.to change(Article.published, :count).by(1)
      expect(response).to redirect_to(assigns(:article))
    end

    it 'edit' do
      expect(@ability.can? :edit, article).to be true
      expect(get :edit, params: { id: article }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, article).to be true
      put :update, params: { id: article, article: { content: 'New text' } }
      expect(response).to redirect_to(assigns(:article))
    end

    it 'destroy' do
      expect(@ability.can? :destroy, article).to be true
      expect{ delete :destroy, params: { id: article } }.to change(Article, :count).by(-1)
      expect(response).to redirect_to(articles_path)
    end
  end

  %i[moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'get index' do
        create_list(:article, 3) # hidden by default
        expect(@ability.can? :index, Article).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:articles).count).to eq(1)
      end

      it 'cannot publish' do
        expect(@ability.cannot? :publish, unpublished_article).to be true
        expect{ put :publish, params: { id: unpublished_article } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Article.published, :count).by(0)
      end

      it 'edit' do
        expect(@ability.cannot? :edit, article).to be true
        expect{ get :edit, params: { id: article } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'update' do
        expect(@ability.cannot? :update, article).to be true
        expect{ put :update, params: { id: article, article: { content: 'New text' } } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'destroy' do
        expect(@ability.cannot? :destroy, article).to be true
        expect{ delete :destroy, params: { id: article } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Article, :count).by(0)
      end

      it 'create' do
        expect(@ability.can? :create, article).to be true
        expect{ post :create, params: { article: attributes_for(:article) } }.to change(Article, :count).by(1)
        actual = assigns(:article)
        expect(response).to redirect_to(actual)
      end

      it 'create change user article_count' do
        expect(@user.articles_count).to eq(0)
        post :create, params: { article: attributes_for(:article) }
        @user.reload
        expect(@user.articles_count).to eq(1)
      end
    end
  end

  describe 'for author' do
    before(:each) do
      sign_in(author)
      @ability = Ability.new(author)
    end

    it 'cannot edit published' do
      expect(@ability.cannot? :edit, article).to be true
      expect{ get :edit, params: { id: article } }.to raise_error(CanCan:: AccessDenied)
    end

    it 'cannot update published' do
      expect(@ability.cannot? :update, article).to be true
      expect{ put :update, params: { id: article, article: { content: 'New text' } } }.to raise_error(CanCan:: AccessDenied)
    end

    it 'cannot destroy published' do
      expect(@ability.cannot? :destroy, article).to be true
      expect{ delete :destroy, params: { id: article } }.to raise_error(CanCan:: AccessDenied)
      expect{ response }.to change(Article, :count).by(0)
    end

    it 'can edit' do
      expect(@ability.can? :edit, unpublished_article).to be true
      expect(get :edit, params: { id: unpublished_article }).to render_template(:edit)
    end

    it 'can update' do
      expect(@ability.can? :update, unpublished_article).to be true
      put :update, params: { id: unpublished_article, article: { content: 'New text' } }
      expect(response).to redirect_to(assigns(:article))
    end

    it 'destroy' do
      expect(@ability.can? :destroy, unpublished_article).to be true
      expect{ delete :destroy, params: { id: unpublished_article } }.to change(Article, :count).by(-1)
      expect(response).to redirect_to(articles_path)
    end


  end

  describe 'unreg user activities should' do
    it 'index' do
      expect(get :index).to render_template(:index)
      expect(assigns(:articles)).not_to be_nil
    end

    it 'get new' do
      expect(get :new).to render_template(:new)
    end

    it 'create' do
      expect{ post :create, params: { article: attributes_for(:article) } }.to change(Article, :count).by(1)
      actual = assigns(:article)
      expect(response).to redirect_to(actual)
    end

    describe 'not' do
      after(:each)      { expect(response).to redirect_to(root_path) }

      it('not edit')   { get :edit, params: { id: article } }

      it 'not update' do
        put :update, params: { id: article, article: { content: 'New text' } }
      end

      it 'not destroy' do
        expect{ delete :destroy, params: { id: article } }.to change(Article, :count).by(0)
      end

      it 'cannot publish' do
        expect{ put :publish, params: { id: unpublished_article } }.to change(Article.published, :count).by(0)
      end
    end
  end
end
