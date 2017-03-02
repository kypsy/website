require 'spec_helper'

describe UsersController, :type => :controller do
  # render_views
  let!(:shane) { create(:shane) }
  describe "GET 'index'" do
    let!(:bookis) { create(:bookis, visible: true) }
    before { sign_in(shane) }

    it "redirects to root" do
      get :index
      expect(response).to be_successful
    end

    context "#search" do
      it "by username field" do
        expect(User).to receive(:search).with("username" => "veganstraightedge").once.and_return User.visible
        get :index, params: {search: "username/veganstraightedge"}
      end
      it "shows everyone" do
        get :index
        expect(assigns(:users)).to include bookis
      end

      it "doesn't show blocked people" do
        shane.blocks << Block.create(blocked_id: bookis.id)
        get :index
        expect(assigns(:users)).to_not include bookis
      end

      it "shows everyone" do
        get :index, params: {search: "bookis"}
        expect(assigns(:users)).to include bookis
      end

      it "doesn't show blocked people" do
        shane.blocks << Block.create(blocked_id: bookis.id)
        get :index, params: {search: "bookis"}
        expect(assigns(:users)).to_not include bookis
      end

      it "redirects if searching on a bad field" do
        get :index, params: {search: "id/1"}
        expect(assigns(:search)).to eq "1"
      end

      it "searches all if no search term" do
        get :index, params: {search: ""}
        expect(assigns(:users)).to include bookis
      end
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', params: {username: "veganstraightedge"}
      expect(response).to be_success
    end

    it "redirect to home if the user doesn't exit" do
      get :show, params: {username: "imnotreal"}
      expect(response).to redirect_to root_path
    end

  end

  describe "GET 'edit'" do
    before {
      allow(shane).to receive(:visible) { true }
      sign_in shane
    }
    it "should be successful" do
      get 'edit'
      expect(response).to be_success
    end
  end

  describe "DELETE 'destroy" do
    let(:bookis) { create(:bookis, visible: true, agreed_to_terms_at: Time.now) }
    before { sign_in(bookis) }
    it "destroys a user" do
      expect { delete :destroy, params: {username: "@bookis"} }.to change(User, :count).by(-1)
    end

    it "redirects to home" do
      delete :destroy, params: {username: "@bookis"}
      expect(response).to redirect_to root_path
    end
  end

  describe "POST 'create'" do
    let(:bookis) { create(:bookis, visible: false, agreed_to_terms_at: nil, email: nil) }
    before { sign_in(bookis) }

    it "redirects to people path" do
      post :create, params: {user: {username: User.generate_username, email: "b@c.com", agreed_to_terms_at: Time.now}}
      expect(response).to redirect_to new_photo_path(getting: "started")
    end

    it "changes user visibility" do
      post :create, params: {user: {username: User.generate_username, email: "b@c.com", agreed_to_terms_at: Time.now}}
      bookis.reload
      expect(bookis.visible).to be_truthy
    end

    it "renders the edit form if there are errors" do
      post :create, params: {user: {username: User.generate_username, email: "b@c.com"}}
      expect(response).to render_template :new
    end
  end

  describe "PATCH 'update'" do
    before {
      allow(shane).to receive(:visible) { true }
      sign_in(shane)
    }

    it "updates name" do
      patch :update, params: {user: {name: "BKS"}}
      expect(response).to redirect_to person_path(shane.username)
    end

    it "doesn't update username" do
      expect { patch :update, params: {user: {username: "BKS"}} }.to_not change(shane, :username)
    end

    it "doesn't update email" do
      expect { patch :update, params: {user: {email: "b@example.com"}} }.to_not change(shane, :email)
    end

    it "updates settings" do
      patch :update, params: {user: {email_crushes: true, admin: true }}
      expect(assigns(:user).admin?).to be_nil
      expect(assigns(:user).email_crushes).to eq true.to_s
    end
  end

end
