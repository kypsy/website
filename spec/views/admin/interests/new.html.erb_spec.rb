require 'rails_helper'

RSpec.describe "admin/interests/new", type: :view do
  before(:each) do
    assign(:admin_interest, Admin::Interest.new(
      :name => "MyString"
    ))
  end

  it "renders new admin_interest form" do
    render

    assert_select "form[action=?][method=?]", admin_interests_path, "post" do

      assert_select "input#admin_interest_name[name=?]", "admin_interest[name]"
    end
  end
end
