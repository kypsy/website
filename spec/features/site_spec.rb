require 'spec_helper'

describe "tests user experience", type: :feature, js: true do
  let!(:bookis) { create(:bookis, bio: "This is my bio", visible: true) }
  let!(:shane)  { create(:shane,                         visible: true) }

  it "does views users, crushes, bookmarks, and stuff" do
    visit "/"
    expect(page).to have_content t(:brand)

    first(:link, "Thousands of People are on #{t(:brand)}").click
    expect(page).to have_content "Everyone"
  end

  context "when logged in" do
    before do
      visit "/"
      first(:link, "Twitter").click
      fill_in('Username', :with => 'dalecooper')
      fill_in('Email', :with => 'dale@example.com')
      check('I agree to the terms')
      click_button("Submit")
      click_link("No Thanks")
    end

    it "rotates an image" do
      visit("/@dalecooper")
      click_link("Add Photo")
      attach_file("or Select an Image", "#{Rails.root}/spec/support/small.png")
      fill_in("Caption", with: "Word")
      click_button("Upload")
      expect(page).to have_content("Word")
      first(:link, "Edit Photo").click
      fill_in("Caption", with: "Wordz")
      expect(page.evaluate_script('$("form").serialize();')).to include "caption%5D=Wordz"
      expect(page.evaluate_script('$("form").serialize();')).to_not include "manipulate"
      click_link("Rotate -90°")
      expect(page.evaluate_script('$("form").serialize();')).to include "manipulate%5D%5Brotate%5D=-90"
      click_link("Rotate 90°")
      click_link("Rotate 90°")
      click_link("Rotate 90°")
      expect(page.evaluate_script('$("form").serialize();')).to include "manipulate%5D%5Brotate%5D=180"
      click_link("Flip Vertical")
      expect(page.evaluate_script('$("form").serialize();')).to include "manipulate%5D%5Bflip%5D=true"
      click_link("Flip Horizontal")
      expect(page.evaluate_script('$("form").serialize();')).to include "manipulate%5D%5Bflop%5D=true"
      click_link("Flip Vertical")
      expect(page.evaluate_script('$("form").serialize();')).to_not include "manipulate%5D%5Bflip"
    end

    it "does everything" do
      visit("/people")
      first(:link, "veganstraightedge").click
      page.find('.message').click
      expect(page).to have_content "New Conversation"

      click_link "Preview"
      expect(page.html).to include "Markdown"

      click_link "Write"
      fill_in("Body", with: "# Hello")

      click_link "Preview"
      expect(page.html).to include "<h1>Hello</h1>"
    end
  end
end
