# encoding: UTF-8
require 'spec_helper'

describe User, :type => :model do
  let(:user)   { create(:user)  }
  let(:bookis) { create(:bookis) }
  let(:shane)  { create(:shane)  }

  it "has an auth token" do
    expect(user.auth_token).to be_present
  end

  it "sets the canonical username" do
    expect(bookis.canonical_username).to eq "bookis"
  end

  it "doesn't allow duplicate names" do
    bookis
    bad = create(:bookis, username: "booKis")
    expect(bad).to be_invalid
    expect(bad.errors[:username]).to include "has already been taken"
  end

  it "should not update the user" do
    user.username = nil
    user.save
    expect(user.errors[:username]).to include "can't be blank"
  end

  it "username can't have spaces" do
    user.username = "Bookis with spaces"
    user.valid?
    expect(user.errors[:username]).to include "can only contain standard characters"
  end

  it "should be able to a have label" do
    Label.create!(name: "straightedge")

    user.label = Label.first
    user.save!

    expect(user.label.name).to eq("straightedge")
  end

  it "should be able to have desired labels" do
    %w(straightedge drug-free).each do |label|
      user.desired_labels.create!(name: label)
    end

    expect(user.desired_labels.map(&:id).sort).to eq Label.all.map(&:id).sort
  end

  describe "merge!" do
    before(:each) do
      sxe    = Label.create(name: "sXe")
      @crunk = Label.create(name: 'crunk')

      user.providers << Provider.create(name: "twitter", uid: '123')
      user.desired_labels << sxe

      @merging_user = User.create(username: "Becker",
                                  bio:      "This should merge into the old user",
                                  name:     "SB",
                                  email:    "test@example.com")
      @merging_user.providers << Provider.create(name: "fb", uid: '456')
      @merging_user.desired_labels << [sxe, @crunk]

      user.merge! @merging_user
    end

    it "Should add crunk to the og user" do
      expect(user.desired_labels).to include @crunk
    end
  end

  describe "avatars" do
    it "assigns the photo as avatar" do
      user.photos.create(remote_image_url: "http://placehold.it/1/1.png")
      expect(user.photos.first.avatar).to  be_truthy
    end
  end

  describe "auth from FB" do
    before { allow_any_instance_of(ImageUploader).to receive(:download!) }
    let(:user) { User.create_for_facebook(OmniAuth.mock_auth_for(:facebook)) }

    it "is valid" do
      expect(user.new_record?).to be_falsey
    end

    it 'sets email_crushes to true' do
      expect(user.email_crushes?).to eq true
    end

    it 'sets email_messages to true' do
      expect(user.email_messages?).to eq true
    end

    it "assigns a remote photo" do
      mock_user = mock_model("User")
      expect(User).to receive(:create!).and_return(mock_user)
      allow(mock_user).to receive(:photos).and_return([])
      expect(mock_user.photos).to receive(:create).with(remote_image_url: "http://placekitten.com/10/10?type=large", avatar: true)
      user
    end
  end

  describe "#available_username" do
    before { shane }
    it "it returns the username it it's available" do
      expect(User.available_username("username")).to eq "username"
    end

    it "doesn't error when a nil username is given" do
      expect {User.available_username(nil)}.to_not raise_error
      expect(User.available_username(nil)).to eq false
    end

    it "a match return a temp user name" do
      expect(User.available_username("Veganstraightedge")).to eq false
    end

    it "a downcase match return a temp user name" do
      expect(User.available_username("veganstraightedge")).to eq false
    end

    it "a user can change usernames" do
      expect(shane.available_username('username')).to eq "username"
    end

    it "a user can have the same user name" do
      expect(shane.available_username('Shane')).to eq "Shane"
    end

    it "a user can have the same user name by downcase" do
      expect(shane.available_username('shane')).to eq "shane"
    end

    it "a user can't have a taken username" do
      expect(bookis.available_username('veganstraightedge')).to eq false
    end

  end

  describe "merging" do
    it "can merge" do
      user2 = User.create(username: "bookis", name: "BS", email: "testbks@example.com")
      user.merge! user2
      user.reload
      expect(user.agreed_to_terms_at).to_not be_blank
    end

    it "doesn't error if the terms aren't agreed to" do
      user = create(:user, agreed_to_terms_at: nil)
      user2 = create(:bookis, agreed_to_terms_at: nil)
      user.merge! user2
      user.reload
      expect(user.agreed_to_terms_at).to be_nil
    end
  end

  describe "settings" do
    before { user.update(settings: {admin: true}) }
    it "has settings" do
      expect(user.settings).to_not be_blank
    end

    it "has admin?" do
      expect(user.admin?).to be_truthy
    end

    it "has featured" do
      expect(user.featured?).to be_nil
    end
  end

  describe "visible users" do
    before { bookis; user; shane }
    it "shows all users" do
      expect(bookis.viewable_users).to include user, shane
      expect(bookis.viewable_users).to_not include bookis
    end

    it "doesn't show invisible users" do
      not_visible = create(:user, visible: false)
      expect(bookis.viewable_users).to_not include not_visible
    end

    it "doesn't show blocked users" do
      bookis.blocks.create(blocked_id: user.id)
      expect(bookis.viewable_users).to_not include user
      expect(bookis.viewable_users).to include shane
    end

    it "doesn't show people who have blocked me" do
      bookis.blocks.create(blocked_id: user.id)
      expect(user.viewable_users).to_not include bookis
      expect(user.viewable_users).to include shane
    end

    it "doesn't show blocked and blocking" do
      bookis.blocks.create(blocked_id: user.id)
      user.blocks.create(blocked_id: shane.id)
      expect(user.viewable_users).to_not include bookis
      expect(user.viewable_users).to_not include shane
    end
  end

  describe "blocks" do
    let(:bookis) { create(:bookis) }
    let(:shane)  { create(:shane) }

    it "with_user for blocked" do
      create(:block, blocked_id: bookis.id, blocker_id: shane.id)
      expect(bookis.block_with_user?(shane)).to be_truthy
    end

    it "with_user for blockee" do
      create(:block, blocked_id: shane.id, blocker_id: bookis.id)
      expect(bookis.block_with_user?(shane)).to be_truthy
      expect(shane.block_with_user?(bookis)).to be_truthy
    end

  end

  describe "#search" do
    let!(:bookis) { create(:bookis, location: "seattle") }
    let!(:shane)  { create(:shane, location: "Los Angeles") }


    it "returns an empty array" do
      expect(User.search("humbug")).to eq []
    end

    it "searches by usernname" do
      expect(User.search("BOOKIS")).to include bookis
      expect(User.search("bookis")).to include bookis
      expect(User.search("bookis smuin")).to_not include bookis

      expect(User.search("username" => "bookis")).to include bookis
    end
    it "can't search by name" do
      expect(User.search("Smuin")).to_not include bookis
      expect(User.search("smuin")).to_not include bookis
      expect(User.search("bookis smuin")).to_not include bookis
    end

    it "finds even with accents" do
      expect(User.search("boökis")).to include bookis
    end

    it "finds by age" do
      expect(User.search(age: 27)).to include bookis
      expect(User.search(age: 27)).to_not include shane
      expect(User.search(age: (26..28)).size).to eq(1)
      expect(User.search(age: (26..32)).size).to eq(2)
    end

    it "finds by a field" do
      expect(User.search(username: "Bookis")).to include bookis
      expect(User.search("seattle")).to    include bookis
    end

    it "searches by label" do
      bookis.update(label: create(:label, name: "Label"))
      expect(User.search("label")).to eq [bookis]
    end

    it "searches by label by field" do
      bookis.update(label: create(:label, name: "Label"))
      expect(User.search(label: "label")).to eq [bookis]
      expect(User.search("label")).to eq [bookis]
    end

    it "can't search on email" do
      expect(User.search(email: shane.email)).to_not include shane
    end
  end

  describe "#inbound_messages" do
    let!(:conversation) { Conversation.create(sender: bookis, recipient: shane) }
    let!(:message) { conversation.messages.create(sender: bookis, recipient: shane) }

    it "is an inbound message for shane" do
      expect(shane.inbound_messages.unread).to include message
    end

    it "isn't if the convo has been deleted" do
      conversation.delete_from_user(shane)
      expect(shane.inbound_messages.unread).to_not include message
    end

  end

  describe '#email_settings' do
    it 'crushes default to false' do
      expect(user.email_crushes).to eq nil
    end
    it 'messages default to false' do
      expect(user.email_messages).to eq nil
    end
  end

end
