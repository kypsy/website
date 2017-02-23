require 'spec_helper'

describe AboutController, :type => :controller do

  describe "GET 'terms'" do
    it "returns http success" do
      get 'terms'
      expect(response).to be_success
    end
  end
  
  describe "GET privacy" do
    it "returns http success" do
      get 'privacy'
      expect(response).to be_success
    end
  end

end
