require "spec_helper"

describe Crush do
  let(:crush) { create(:crush) }
  describe 'notify' do
    it 'pings resque' do
      expect(Resque).to receive(:enqueue).with(NotificationJob, :new_crush, crush.id)
      crush.notify
    end
  end

  describe '#needs_notify' do
    it 'does if recipient has email_crushes to true' do
      crush.crushee.email_crushes = true
      expect(crush.needs_notify?).to eq true
    end
    
    it 'does not if recipient has email_crushs to false' do
      crush.crushee.email_crushes = false
      expect(crush.needs_notify?).to eq false
    end
  end
end
