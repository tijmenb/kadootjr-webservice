require "bol_api"
require "fakeweb"
Encoding.default_external = Encoding::UTF_8

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(:get,
  "https://api.bol.com/catalog/v4/lists/?apikey=XXX&ids=1&format=json&dataoutput=products&limit=100",
  body: File.read("spec/fakeweb_responses/search.json"))

describe BolAPI::Client do
  describe "#search" do
    it "returns a list of results" do
      client = BolAPI::Client.new('XXX')
      results = client.search(category_ids: [1])
      results.first.should be_a(BolAPI::Product)
    end
  end
end
