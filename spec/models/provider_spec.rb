require 'spec_helper'

describe Provider, :type => :model do
  let!(:auth) { OmniAuth.mock_auth_for(:twitter) }
  let!(:provider) { create(:twitter, uid: auth.uid) }

  describe "#from_auth" do
    it "assigns the handle" do
      expect(Provider.from_auth(auth)).to eq provider
    end

    it "updates last_login_at" do
      Provider.from_auth(auth)
      expect(provider.reload.last_login_at).to_not be_blank
    end

    it "updates params passed in" do
      Provider.from_auth(auth, ip_address: "127.0.0.1")
      expect(provider.reload.ip_address).to eq "127.0.0.1"
    end

    it "assigns the handle" do
      Provider.from_auth(auth)
      expect(provider.reload.handle).to eq "dalecooper"
    end

    it "assigns the name if no handle" do
      auth.info.nickname = nil
      Provider.from_auth(auth)
      expect(provider.reload.handle).to eq "dale cooper"
    end


    context "when different twitter handle but same email" do
      let(:new_auth) { OmniAuth.mock_auth_for(:twitter) }
      it "creates with no email" do
        Provider.from_auth(auth)
        new_auth.uid = "1234fake"
        expect { Provider.from_auth(new_auth) }.to_not raise_error
      end
    end

    context "when twitter handle changes" do
      let(:new_auth) { OmniAuth.mock_auth_for(:twitter) }
      it "doesn't throw an error" do
        Provider.from_auth(auth)
        new_auth.info.nickname = "Goose"
        expect { Provider.from_auth(new_auth) }.to_not raise_error
      end

      it "returns the same provider" do
        provider = Provider.from_auth(auth)
        new_auth.info.nickname = "Goose"
        expect(Provider.from_auth(new_auth).id).to eq provider.id
      end
    end
  end

  describe "#destroy" do
    it "doesn't work" do
      expect { provider.destroy }.to raise_error Provider::CantBeDestroyedError
    end

    it "works if the user is being destroyed too" do
      user = create(:user)
      user.providers << provider
      user.destroy
      expect {provider.reload}.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
