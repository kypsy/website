require 'spec_helper'

describe PhotosController, :type => :controller do
  context "when signed in" do

    before {
      sign_in
      allow(controller).to receive(:confirm_photo_belongs_to_user) { true }
    }

    describe "GET 'new'" do
      it "should be successful" do
        get 'new'
        expect(response).to be_success
      end
    end

    describe "GET 'edit'" do
      let(:photo) { mock_model("Photo") }

      it "should be successful" do
        expect(Photo).to receive(:find).with("1").and_return(photo)
        get 'edit', params: {id: 1}
        expect(response).to be_success
      end
    end
  end

  describe "POST 'email'" do
    let(:bookis) { create(:bookis) }
    let(:request) { post :email, params: {mandrill_events: [mandrill_callback(bookis)].to_json }}
    it "is successful" do
      request
      expect(response.status).to eq 201
    end

    it "creates a photo" do
      expect { request }.to change(Photo, :count).by(1)
    end

    context "when it doesn't save" do
      before { allow_any_instance_of(Photo).to receive(:save) { false }}

      it "returns a 422" do
        request
        expect(response.status).to eq 422
      end
    end
  end
end
