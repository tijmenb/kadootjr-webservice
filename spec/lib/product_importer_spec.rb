require "spec_helper"
require './lib/product_importer'
require './lib/product_list'

describe ProductImporter do
  describe "#add_or_update_products" do
    it "adds bol products to Redis" do
      importer = ProductImporter.new('vriendje')
      first = double(:product, id: '12', as_json: { 'x' => 'y' }, rating: 40)
      second = double(:product, id: '21', as_json: { 'x' => 'y' }, rating: 50)
      importer.add_or_update_products([first, second])
      ProductList.new('vriendje').raw_products.size.should == 2
    end
  end
end
