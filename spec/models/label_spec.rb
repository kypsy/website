require 'spec_helper'

describe Label, :type => :model do
  it "should have a name" do
    label = Label.new
    label.name = "straightedge"
    label.save
    expect(label).to be_valid
  end

  it "should be invalid with no name" do
    label = Label.new
    label.save
    expect(label).to be_invalid
  end

  # it "should build options for select correctly" do
  #   @l1 = Label.create!(name: "straightedge")
  #   @l2 = Label.create!(name: "drunk")
  #
  #   labels = [
  #     ["straightedge", @l1.id],
  #     ["drunk",        @l2.id]
  #   ]
  #
  #   Label.options_for_select.first.first.should == labels.first.first
  #   Label.options_for_select.last.last.should   == labels.last.last
  # end
end
