require "spec_helper"
require './lib/product_syncer'

describe ProductSyncer do
  describe "#update" do
    it "it updates everything" do
      syncer = ProductSyncer.new
      syncer.should_receive(:update_group).at_least(10)
      syncer.update
    end
  end

  describe "#update_group" do
    it "it updates everything" do
      Group.stub all: [{ 'id' => 'testertje', 'categories' => [1,2,3,4] }]
      syncer = ProductSyncer.new
      downloader = double(:downloader)
      importer = double(:importer)
      ProductDownloader.stub new: downloader
      ProductImporter.stub new: importer

      downloader.should_receive(:products).with(1).and_return(['what'])
      downloader.should_receive(:products).with(2).and_return(['hai'])
      downloader.should_receive(:products).with(3).and_return([])
      downloader.should_receive(:products).with(4).and_return([])
      importer.should_receive(:add_or_update_products).with(kind_of(Array))

      syncer.update_group('testertje')
    end
  end
end
