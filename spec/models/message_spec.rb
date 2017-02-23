require "spec_helper"
describe Message do
  let(:message) { create(:message) }
  describe 'notify' do
    it 'pings resque' do
      expect(Resque).to receive(:enqueue).with(NotificationJob, :new_message, message.id)
      message.notify
    end
  end

  describe '#needs_notify' do
    it 'does if recipient has email_messages to true' do
      message.recipient.email_messages = true
      expect(message.needs_notify?).to eq true
    end
    it 'does not if recipient has email_messages to false' do
      message.recipient.email_messages = false
      expect(message.needs_notify?).to eq false
    end
  end
end
