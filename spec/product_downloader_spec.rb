require './lib/product_downloader'

describe ProductDownloader do
  describe "#instance_method" do
    it "does something" do
      Redis.current.zadd("kadootjr:categories:1", 23, '123')
      hash = { 'id' => '123', 'title' => 'Hello hello'}
      CategoryDownloader.new(1).add_or_update_product(hash)
      Redis.current.hgetall("kadootjr:product:123").should == hash
      Redis.current.zscore("kadootjr:categories:1", "123").should == 23
    end
  end
end
