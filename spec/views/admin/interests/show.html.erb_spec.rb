require 'rails_helper'

RSpec.describe "admin/interests/show", type: :view do
  before(:each) do
    @admin_interest = assign(:admin_interest, Admin::Interest.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
