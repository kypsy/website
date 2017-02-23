require 'spec_helper'

describe SearchesController, :type => :controller do
  let!(:shane) { create(:shane) }
  let!(:bookis) { create(:bookis, visible: true) }

  before { sign_in(shane) }

  describe "GET 'index'" do
    it "returns http success" do
      get :index, params: {column: :diets}
      expect(response).to be_success
    end

  end

end
