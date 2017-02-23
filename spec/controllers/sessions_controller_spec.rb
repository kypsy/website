require 'spec_helper'

describe SessionsController, :type => :controller do
  describe "with facebook" do
    before { request.env["omniauth.auth"] = auth }
    let(:auth) { OmniAuth.mock_auth_for(:facebook) }
    it "sign up creates a user" do
      expect { get :create, params: {provider: "facebook"} }.to change(User, :count).by(1)
      expect(cookies[:auth_token]).to_not be_blank
    end

    it "signs in the user" do
      expect(controller.request.env).to receive(:[]).with("omniauth.auth").once.and_return(auth)
      expect(controller.request.env).to receive(:[]).at_least(:once).and_call_original
      user = User.create(username: "Shane", name: "SB", email: "test@example.com", birthday: 15.years.ago, agreed_to_terms_at: Time.now)
      user.providers << Provider.create(name: auth["provider"], uid: auth["uid"])
      expect { get :create, params: {provider: "facebook"} }.to change(User, :count).by(0)
      expect(cookies[:auth_token]).to_not be_blank
    end

    it 'creates a credential' do
      expect { get :create, params: {provider: "facebook"} }.to change(Credential, :count).by(1)
    end
  end

  describe "sign up with twitter" do
    let(:auth) { OmniAuth.mock_auth_for(:twitter) }
    before { request.env["omniauth.auth"] = auth }
    it "is successful" do
      expect { get :create, params: {provider: "twitter"} }.to change(User, :count).by(1)
    end
  end

end
