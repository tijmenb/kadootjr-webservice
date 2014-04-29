require './lib/bol_api/product'

describe BolAPI::Product do
  describe ".initialize" do
    let :product do
      product_data = JSON.parse(File.read("spec/fakeweb_responses/product.json"))
      BolAPI::Product.new(product_data)
    end

    it "initializes with all common attributes" do
      product.id.should == '9200000011366603'
      product.short_description.should start_with 'New York, voorjaar 2008. De jonge auteur Marcus Goldman'
    end

    it "creates fancy accessors for the URLs" do
      product.desktop_url.should == "http://www.bol.com/nl/p/de-waarheid-over-de-zaak-harry-quebert/9200000011366603/"
      product.mobile_url.should == "https://m.bol.com/nl/p/de-waarheid-over-de-zaak-harry-quebert/9200000011366603/"
    end

    it "creates a hash for the images" do
      product.image.should == "http://s.s-bol.com/imgbase0/imagebase/large/FC/3/0/6/6/9200000011366603.jpg"
    end

    it "fetches the Bol.com price & availability" do
      product.price.should == 19.9
      product.availability_description.should == 'Vandaag besteld, woensdag in huis'
    end
  end

  describe ".initialize with a music CD" do
    let :product do
      product_data = JSON.parse(File.read("spec/fakeweb_responses/muziek_product.json"))
      BolAPI::Product.new(product_data)
    end

    it "it's title is cool" do
      product.title.should == 'By Absence Of The Sun - Triggerfinger'
    end
  end
end
