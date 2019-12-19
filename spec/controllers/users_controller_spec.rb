require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let!(:user) { create(:user) }

  describe 'admin activities should' do
    login_user(:admin)

    it 'edit' do
      expect(@ability.can? :edit, user).to be true
      expect(get :edit, params: { id: user }).to render_template(:edit)
    end

    it 'update' do
      expect(@ability.can? :update, user).to be true
      expect(put :update, params: { id: user, user: { login: 'Newlogin', profile: attributes_for(:profile) } }).to redirect_to(assigns(:user))
    end
  end

  %i[moderator user].each do |role|
    describe "user with #{role} role activities should" do
      login_user(role)

      it 'cannot edit not own' do
        expect(@ability.cannot? :edit, user).to be true
        expect{get :edit, params: { id: user }}.to raise_error(CanCan:: AccessDenied)
      end

      it 'cannot update not own' do
        expect(@ability.cannot? :update, user).to be true
        expect{put :update, params: { id: user, user: { profile: attributes_for(:profile) } } }.to raise_error(CanCan:: AccessDenied)
      end

      it 'edit own' do
        expect(@ability.can? :edit, @user).to be true
        expect(get :edit, params: { id: @user }).to render_template(:edit)
      end

      it 'update own' do
        expect(@ability.can? :update, @user).to be true
        expect(put :update, params: { id: @user, user: { profile: attributes_for(:profile) } }).to redirect_to(assigns(:user))
      end
    end
  end

  describe 'unreg user activities should' do
    it('index') { expect(get :index ).to render_template(:index) }
    it('show')  { expect(get :show, params: { user_id: user, id: user}).to render_template(:show) }

    describe 'not' do
      after(:each)  { expect(response).to redirect_to(root_path) }

      it('edit')    { get :edit, params: { id: user } }
      it('update')  { put :update, params: { id: user, user: { profile: attributes_for(:profile) } } }
    end
  end
end
