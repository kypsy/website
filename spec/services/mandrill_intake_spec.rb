require 'spec_helper'
describe MandrillIntake do
  
  describe "#from_mandrill" do
    let(:bookis) { create(:bookis) }

    let(:photo) { MandrillIntake.new(mandrill_callback(bookis)).photo }
    
    it "is a valid photo" do
      expect(photo).to be_valid
    end
    
    it "creates a photo" do
      expect {photo.save}.to change(Photo, :count).by(1)
    end
    
    it "belongs to the user by email address" do
      expect(photo.user).to eq bookis
    end
    
    it "concats the subject and body" do
      expect(photo.caption).to eq "This is a subject"
    end
    
    context "when base64 encoded" do
      let(:photo) { MandrillIntake.new(mandrill_callback(bookis, base64: true)).photo }
      
      it "decodes the content" do
        expect {photo.save}.to change(Photo, :count).by(1)
      end
    end
      
  end
end
