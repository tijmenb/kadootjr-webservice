require "spec_helper"

require './lib/product_importer'
require './lib/product_list'

describe ProductImporter do
  describe "#import" do
    it "imports a Bol.com category into Redis" do
      ProductImporter.new(category: '12', group: 'broer').import
      ProductList.new('broer').all_products.size.should == 2
    end
  end
end
