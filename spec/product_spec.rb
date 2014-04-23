require './lib/bol_api/product'

describe BolAPI::Product do
  describe ".initialize" do
    let :product do
      data = JSON.parse(File.read("spec/fakeweb_responses/search.json"))['products'].first
      BolAPI::Product.new(data)
    end

    it "initializes with all common attributes" do
      product.id.should == '9200000011366603'
      product.short_description.should start_with 'New York, voorjaar 2008. De jonge auteur Marcus Goldman'
    end

    it "creates fancy accessors for the URLs" do
      product.desktop_url.should == "http://partnerprogramma.bol.com/click/click?p=1&t=url&s=21278&url=http%3A//www.bol.com/nl/p/de-waarheid-over-de-zaak-harry-quebert/9200000011366603/&f=TXL"
      product.mobile_url.should == "http://partnerprogramma.bol.com/click/click?p=1&t=url&s=21278&url=https%3A//m.bol.com/nl/p/de-waarheid-over-de-zaak-harry-quebert/9200000011366603/&f=TXL"
    end

    it "creates a hash for the images" do
      product.images[:extra_large].should == "http://s.s-bol.com/imgbase0/imagebase/large/FC/3/0/6/6/9200000011366603.jpg"
    end

    it "fetches the Bol.com price & availability" do
      product.price.should == 19.9
      product.availability_description.should == 'Vandaag besteld, woensdag in huis'
    end
  end
end
