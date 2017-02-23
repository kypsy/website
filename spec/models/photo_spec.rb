require 'spec_helper'

describe Photo, :type => :model do
  let(:photo) { create(:photo) }
  describe "validations" do
    let(:photo) { build(:photo, image: nil) }
    it "isn't valid without an image" do
      expect(photo).to be_invalid
      expect(photo.errors[:image]).to include "can't be blank"
    end
  end
  
  describe "cleaning url" do
    let(:photo) { Photo.new(remote_image_url: "http://placekitten.com/1/1?blah") }
  end
  
  describe "manipulate" do
    context "with a valid manipulation" do
      
      let(:image) { photo.image }
      let(:source) { double(:source) }
      before do
        photo
      end
      
      it "rotates the image 90 degrees" do
        expect(image).to receive(:manipulate!).and_yield(source)
        expect(source).to receive(:rotate!).with(90)
        photo.update(manipulate: {rotate: 90})
      end
      
      it "rotates it with 180" do
        expect(image).to receive(:manipulate!).and_yield(source)
        expect(source).to receive(:rotate!).with(180)
        photo.update(manipulate: {rotate: 180})
      end
      
      it "flips the image" do
        expect(image).to receive(:manipulate!).and_yield(source)
        expect(source).to receive(:flip!)
        photo.update(manipulate: {flip: true})
      end
      
      it "flops the image" do
        expect(image).to receive(:manipulate!).and_yield(source)
        expect(source).to receive(:flop!)
        photo.update(manipulate: {flop: true})
      end
    end
    
    it "doesn't raise an error without a valid key" do
      expect { photo.update(manipulate: {blop: true}) }.to_not raise_error
      expect { photo.update(manipulate: {rotate: nil}) }.to_not raise_error
      expect { photo.update(manipulate: nil) }.to_not raise_error
      expect { photo.update(manipulate: "trop") }.to_not raise_error
    end

  end

end
