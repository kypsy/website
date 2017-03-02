require 'spec_helper'

describe CrushesController, :type => :controller do
  let!(:bookis) { create(:bookis) }
  let!(:shane)  { create(:shane)  }
  before { sign_in(bookis) }
  describe "POST 'create'" do
    let(:make_request) { post :create, params: {username: shane.username} }
    it "creates a crush" do
      expect { post :create, params: {username: shane.username} }.to change(Crush, :count).by(1)
    end

    it 'queues a job' do
      shane.email_crushes = true
      shane.save
      expect_any_instance_of(Crush).to receive(:notify)
      make_request
    end

    it 'does not queue a job' do
      expect_any_instance_of(Crush).to_not receive(:notify)
      make_request
    end

  end

  describe "DELETE 'destroy'" do
    it "deletes a crush" do
      bookis.crushings.create(crushee_id: shane.id)
      expect { delete :destroy, params: {username: shane.username} }.to change(Crush, :count).by(-1)
    end
  end
end
