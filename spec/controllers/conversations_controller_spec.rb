require 'spec_helper'

describe ConversationsController, :type => :controller do
  let(:shane) { User.create(username: "Shane",  name: "SB", email: "test@example.com", visible: true, agreed_to_terms_at: Time.now) }
  let(:user)  { User.create(username: "Bookis", name: "BS", email: "bs@example.com",   visible: true, agreed_to_terms_at: Time.now) }

  let!(:conversation) { user.conversations.create(user_id: user.id, recipient_id: shane.id) }
  before { sign_in(user) }

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      expect(response).to be_success
    end

    it "doesn't show it if they have deleted it" do
      conversation.delete_from_user(user)
      get :index
      expect(assigns(:conversations)).to_not include conversation
    end
  end

  describe "GET 'show'" do

    it "should be successful" do
      get 'show', params: {username: shane.username}
      expect(response).to be_success
      expect(assigns(:conversation)).to eq conversation
    end
  end

  describe "DELETE 'destroy'" do
    let(:request) { delete :destroy, params: {username: shane.username }}
    it "updates the conversations" do
      request
      conversation.reload
      expect(conversation.hidden_from_user_id).to eq user.id
    end

    it "actually deletes the convo" do
      request
      allow(controller).to receive(:current_user) { shane }
      expect { delete :destroy, params: {username: user.username} }.to change(Conversation, :count).by(-1)
    end

    it "doesn't actually delete a convo if the same person delete it twice" do
      request
      before = Conversation.count
      expect { delete :destroy, params: {username: shane.username} }.to_not change(Conversation, :count).from(before)
    end

    it "deletes the convo for one person" do
      request
      get 'show', params: {username: shane.username}
      expect(response).to be_successful
    end

    it "loads show for other user" do
      request
      allow(controller).to receive(:current_user) { shane }
      get :show, params: {username: user.username}
      expect(response).to be_successful
    end
  end

end
