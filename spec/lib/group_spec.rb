require "spec_helper"
require "./lib/group"

describe Group do
  describe "#find" do
    it "finds a group by ID" do
      group = { 'id' => 'he', 'ha' => 'hoi' }
      Group.stub all: [group]
      Group.find('he').should == group
    end
  end
end
