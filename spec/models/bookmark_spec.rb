require 'spec_helper'

describe Bookmark, :type => :model do
  let(:bookmark) { Bookmark.new(user_id: 1, bookmarkee_id: 2) }

  it "is valid" do
    expect(bookmark).to be_valid
  end
end
