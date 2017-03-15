require "rails_helper"

RSpec.describe Admin::InterestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/interests").to route_to("admin/interests#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/interests/new").to route_to("admin/interests#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/interests/1").to route_to("admin/interests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/interests/1/edit").to route_to("admin/interests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/interests").to route_to("admin/interests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/interests/1").to route_to("admin/interests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/interests/1").to route_to("admin/interests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/interests/1").to route_to("admin/interests#destroy", :id => "1")
    end

  end
end
