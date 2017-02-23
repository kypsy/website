require 'spec_helper'

describe MessagesController, :type => :controller do
  let(:user)  { create(:shane) }
  let(:user2) { create(:bookis) }
  let(:conversation) { user.outbound_conversations.create(recipient: user2) }
  let(:request) { get 'new', params: {username: user2.username} }
  before do
    sign_in(user)
  end

  describe "GET 'new'" do
    it "should be successful" do
      request
      expect(response).to be_success
    end

    it "is not success if current user age inappropriate" do
      user.update(birthday: 17.years.ago)
      request
      expect(response).to redirect_to people_path
    end

    it "is not success if recipient age inappropriate" do
      user2.update(birthday: 17.years.ago)
      request
      expect(response).to redirect_to people_path
    end

    it "assigns the correct conversation" do
      conversation
      request
      expect(assigns(:conversation)).to eq conversation
    end

    it "is not success if recipient age inappropriate with new convo" do
      user2.update(birthday: 17.years.ago)
      request
      expect(response).to redirect_to people_path
    end

    it "Renders a new conversation" do
      conversation.update(sender: create(:user))
      request
      expect(response).to be_successful
    end


  end

  describe "POST 'create'" do
    let(:make_request) { post 'create', params: {username: user2.username, message: {body: "Body"}} }
    it "should be successful" do
      make_request
      expect(response).to redirect_to conversation_path(user2.username)
    end

    it 'queues a job' do
      user2.email_messages = true
      user2.save
      expect_any_instance_of(Message).to receive(:notify)
      make_request
    end

    it 'does not queue a job' do
      expect_any_instance_of(Message).to_not receive(:notify)
      make_request
    end

    it "is not success if age inappropriate" do
      user.update(birthday: 21.years.ago)
      user2.update(birthday: 10.years.ago)
      post 'create', params: {username: user2.username, message: {body: "Body"}}
      expect(response).to redirect_to conversations_path
      expect(flash[:notice]).to include 'You can\'t send a message to that user'
    end

    describe "blocked" do
      it "should redirect back to the convo" do
        allow_any_instance_of(User).to receive(:block_with_user?) { true }
        post 'create', params: {username: user2.username, message: {body: "Body"}}
        expect(response).to redirect_to conversations_path
        expect(flash[:notice]).to include "@#{user2.username} is not available to message"
      end
    end
  end

end
