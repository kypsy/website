require 'spec_helper'

describe RedFlag, :type => :model do
  let(:red_flag) { create(:red_flag) }

  it "belongs_to a user" do
    expect(red_flag.flaggable).to be_a User
  end

  it "is dependent on the user" do
    red_flag
    expect { red_flag.flaggable.destroy }.to change(RedFlag, :count).by(-1)
  end

  it "is dependent on a photo" do
    red_flag = create(:red_flag, flaggable: create(:photo))
    expect { red_flag.flaggable.destroy }.to change(RedFlag, :count).by(-1)
  end

  it "belongs_to a reporter" do
    expect(red_flag.reporter).to be_a User
  end

  describe "validations" do

    it "is valid" do
      expect(red_flag).to be_valid
    end

    it "has a user" do
      red_flag.flaggable_id = nil
      expect(red_flag).not_to be_valid
    end

    it "has a user" do
      red_flag.reporter_id = nil
      expect(red_flag).not_to be_valid
    end

    it "scopes by user and reporter" do
      red_flag
      expect(build(:red_flag, flaggable_id: red_flag.flaggable_id, reporter_id: red_flag.reporter_id)).not_to be_valid
    end

    it "can have a duplicate user id" do
      red_flag
      expect(build(:red_flag, flaggable_id: red_flag.flaggable_id, reporter_id: 0)).to be_valid
    end

    it "can have a duplicate reporter id" do
      red_flag
      expect(build(:red_flag, flaggable_id: 0, reporter_id: red_flag.reporter_id)).to be_valid
    end

    it "can have a duplicate with a different type" do
      red_flag
      expect(build(:red_flag, flaggable_id: red_flag.flaggable_id, reporter_id: red_flag.reporter_id, flaggable_type: "Photo")).to be_valid
    end

  end

  describe "slug" do
    it "sets the slug on creation" do
      expect(red_flag.slug).to eq "user-#{red_flag.flaggable_id}"
    end
  end
end
