require 'spec_helper'

describe WelcomeController, :type => :controller do
  let!(:user) { create(:user, visible: true) }
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      expect(response).to be_success
    end
    
    describe "logged in" do
      before { allow(controller).to receive(:current_user) { user } }
      it "calls viewable users on current user" do
        expect(user).to receive(:viewable_users).once.and_return(User.all)
        get :index
      end
      
      describe "blocks" do
        let!(:bookis) { create(:bookis) }
      
        it "shows bookis by default" do
          get :index
          expect(assigns(:users)).to include bookis
        end
      
        it "does not show bookis" do
          create(:block, blocker_id: user.id, blocked_id: bookis.id)
          get :index
          expect(assigns(:users)).to_not include bookis
        end

        it "does not show shane if bookis is logged in" do
          sign_in(bookis)
          create(:block, blocker_id: user.id, blocked_id: bookis.id)
          get :index
          expect(assigns(:users)).to_not include user
        end
      
        it "includes user by default" do
          get :index
          expect(assigns(:users)).to_not include user
          expect(assigns(:users)).to include bookis
        end
      end
    end
  end
end
