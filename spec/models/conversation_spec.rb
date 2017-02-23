require 'spec_helper'

describe Conversation, :type => :model do
  let(:sender)  { User.create(username: "Shane",  name: "SB", email: "test@example.com", birthday: 25.years.ago, visible: true, agreed_to_terms_at: Time.now) }
  let(:recipient) { User.create(username: "Bookis", name: "BS", email: "bs@example.com",   birthday: 25.years.ago, visible: true, agreed_to_terms_at: Time.now) }

  let(:conversation) { Conversation.create(sender: sender, recipient: recipient) }

  it "is valid" do
    expect(conversation).to be_valid
  end
  
  it "finds by another user" do
    expect(sender.conversations).to include conversation
  end

  describe "age validation" do
    it "has an error message if age inappropriate" do
      sender.update(birthday: 17.years.ago)
      expect(conversation.errors[:restricted]).to include "You can't send a message to that user"
    end
  end
  
  describe "deletes from a user" do
    it "removes it from the deleting users" do
      message = conversation.messages.create(recipient_id: recipient.id, sender_id: sender.id, body: "blah", unread: true)
      conversation.update(hidden_from_user_id: recipient.id)
      expect(recipient.conversations.not_deleted(recipient)).to_not            include conversation
      expect(sender.conversations.not_deleted(sender)).to                      include conversation
      expect(sender.conversations.with_user(recipient).not_deleted(sender)).to include conversation
    end
    
    it "updates hidden_from_user_id on the first attempt" do
      expect {conversation.delete_from_user(sender)}.to change(conversation, :hidden_from_user_id).to(sender.id)
      expect(sender.conversations.not_deleted(sender)).to_not include conversation
      expect(recipient.conversations.with_user(sender)).to include conversation
    end
    
    it "actually deletes the record on the second delete" do
      conversation.delete_from_user(sender)
      conversation.delete_from_user(recipient)
      expect { conversation.reload }.to raise_error ActiveRecord::RecordNotFound
    end
    
    it "remove the hidden_from_user_id when a new message is added" do
      conversation.update(hidden_from_user_id: recipient.id)
      conversation.messages.create(sender: sender, recipient: recipient, body: "Hello")
      expect(conversation.reload.hidden_from_user_id).to be_nil
    end
  end
end
