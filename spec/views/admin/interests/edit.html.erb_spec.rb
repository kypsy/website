require 'rails_helper'

RSpec.describe "admin/interests/edit", type: :view do
  before(:each) do
    @admin_interest = assign(:admin_interest, Admin::Interest.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit admin_interest form" do
    render

    assert_select "form[action=?][method=?]", admin_interest_path(@admin_interest), "post" do

      assert_select "input#admin_interest_name[name=?]", "admin_interest[name]"
    end
  end
end
