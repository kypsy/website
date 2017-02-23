require 'spec_helper'

describe RedFlagsController, :type => :controller do
  let(:user) { create(:user) }
  let(:reporter) { create(:user) }
  before { sign_in(reporter) }
  describe "POST 'create'" do
    let(:request) { post :create, params: {id: user.id, red_flag: {flaggable_type: "User"} }}
    it "is a redirect to the flagged user" do
      request
      expect(response).to redirect_to user_path(user)
      expect(flash[:notice]).to eq "Flagged!"
    end

    it "creates a redflag" do
      expect { request }.to change(RedFlag, :count).by(1)
    end

    it "redirect to user" do
      allow_any_instance_of(RedFlag).to receive(:save) { false }
      request
      expect(flash[:notice]).to eq "Already flagged"
    end

    context "when a photo" do
      it "redirects to the users page" do
        photo = create(:photo, user: user)
        post :create, params: {id: photo.id, red_flag: {flaggable_type: "Photo"}}
        expect(response).to redirect_to user_path(user)
      end
    end
  end
end
