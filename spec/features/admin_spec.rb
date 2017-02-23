require 'spec_helper'

describe "admin", type: :feature, js: true do
  let!(:bookis) { create(:bookis, bio: "This is my bio", visible: true, settings: {featured: true}, admin: true) }
  let!(:shane)  { create(:shane, featured: true, visible: true)  }

  it "manages things" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(bookis)
    visit "/admin"
    expect(current_path).to eq "/admin"

    visit person_path(shane)

    click_button "Flag @#{shane.username} as inappropriate"

    visit person_path(shane)
    click_link "Block @#{shane.username}"

    expect(page).to have_selector ".alert"
    expect(page).to have_selector ".unblock"

    click_link "ADMIN"
    click_link "user-#{shane.id}"
    click_button "Delete User"
    expect(current_path).to eq "/admin"
    visit person_path(shane)
    expect(current_path).to eq "/"
  end
end
