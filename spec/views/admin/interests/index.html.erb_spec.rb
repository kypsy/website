require 'rails_helper'

RSpec.describe "admin/interests/index", type: :view do
  before(:each) do
    assign(:admin_interests, [
      Admin::Interest.create!(
        :name => "Name"
      ),
      Admin::Interest.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of admin/interests" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
