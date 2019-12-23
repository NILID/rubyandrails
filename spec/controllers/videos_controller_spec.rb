require 'rails_helper'

describe VideosController do
  let!(:video) { create(:video) }
  let(:author) { video.user }

  describe 'admin activities should' do
    login_user(:admin)

    it 'edit' do
      expect(@ability.can? :edit, video).to be true
      expect(get :edit, params: { id: video }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, video).to be true
      put :update, params: { id: video, video: { content: 'New text' } }
      expect(response).to redirect_to(assigns(:video))
    end

    it 'destroy' do
      expect(@ability.can? :destroy, video).to be true
      expect{ delete :destroy, params: { id: video } }.to change(Video, :count).by(-1)
      expect(response).to redirect_to(videos_path)
    end
  end

  %i[moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'get index' do
        create_list(:video, 3)
        expect(@ability.can? :index, Video).to be true
        expect(get :index).to render_template(:index)
        expect(assigns(:videos).count).to eq(4)
      end

      it 'edit' do
        expect(@ability.cannot? :edit, video).to be true
        expect{ get :edit, params: { id: video } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'update' do
        expect(@ability.cannot? :update, video).to be true
        expect{ put :update, params: { id: video, video: { content: 'New text' } } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'destroy' do
        expect(@ability.cannot? :destroy, video).to be true
        expect{ delete :destroy, params: { id: video } }.to raise_error(CanCan:: AccessDenied)
        expect{ response }.to change(Video, :count).by(0)
      end

      it 'create' do
        expect(@ability.can? :create, video).to be true
        expect{ post :create, params: { video: attributes_for(:video) } }.to change(Video, :count).by(1)
        actual = assigns(:video)
        expect(response).to redirect_to(actual)
      end
    end
  end

  describe 'for author' do
    before(:each) do
      sign_in(author)
      @ability = Ability.new(author)
    end

    it 'cannot edit published' do
      expect(@ability.cannot? :edit, video).to be true
      expect{ get :edit, params: { id: video } }.to raise_error(CanCan:: AccessDenied)
    end

    it 'cannot update published' do
      expect(@ability.cannot? :update, video).to be true
      expect{ put :update, params: { id: video, video: { content: 'New text' } } }.to raise_error(CanCan:: AccessDenied)
    end

    it 'cannot destroy published' do
      expect(@ability.cannot? :destroy, video).to be true
      expect{ delete :destroy, params: { id: video } }.to raise_error(CanCan:: AccessDenied)
      expect{ response }.to change(Video, :count).by(0)
    end
  end

  describe 'unreg user activities should' do
    it 'index' do
      expect(get :index).to render_template(:index)
      expect(assigns(:videos)).not_to be_nil
    end


    describe 'not' do
      after(:each)      { expect(response).to redirect_to(root_path) }

      it 'get new' do
        get :new
      end

      it 'create' do
        expect{ post :create, params: { video: attributes_for(:video) } }.to change(Video, :count).by(0)
      end

      it('not edit')   { get :edit, params: { id: video } }

      it 'not update' do
        put :update, params: { id: video, video: { content: 'New text' } }
      end

      it 'not destroy' do
        expect{ delete :destroy, params: { id: video } }.to change(Video, :count).by(0)
      end
    end
  end
end
