require 'spec_helper'

describe Admin::RedFlagsController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      sign_in(create(:user, admin: true))
      get 'index'
      expect(response).to be_success
    end
  end

end
