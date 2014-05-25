require "spec_helper"
require "./lib/product_list"

describe ProductList do
  describe "#figure_paging" do
    it "works" do
      list = ProductList.new('asd')
      list.paging(0, 25).should == [0, 24]
      list.paging(1, 25).should == [25, 49]
    end
  end
end
