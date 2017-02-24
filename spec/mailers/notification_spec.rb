require "spec_helper"

describe Notification do
  let(:message) { create(:message) }
  describe "new_message" do
    let(:mail) { Notification.new_message(message.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{t(:brand)}: You have a new message from @Sen-Der")
      expect(mail.to).to eq(["r@example.com"])
      expect(mail.from).to eq([t(:hq_email)])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('href="http://example.com/@Sen-Der/conversation"')
    end
  end

  describe "new_crush" do
    let(:crush) {create(:crush) }
    let(:mail) { Notification.new_crush(crush.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{t(:brand)}: You were crushed on by @Sen-Der")
      expect(mail.to).to eq(["r@example.com"])
      expect(mail.from).to eq([t(:hq_email)])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('href="http://example.com/@Sen-Der"')
    end
  end

end
