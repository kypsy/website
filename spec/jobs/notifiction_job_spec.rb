require "spec_helper"

describe NotificationJob do
  describe '.perform' do
    context 'when given a new message' do
      let(:job) { NotificationJob }
      it 'sends an email' do
        allow(Message).to receive(:find).with(1).and_return(create(:message))
        expect { job.perform(:new_message, 1) }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end
