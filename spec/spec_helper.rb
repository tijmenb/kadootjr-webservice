ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'fakeweb'
require 'redis'
require 'rack/test'

Redis.current.select 4

FakeWeb.allow_net_connect = false
Encoding.default_external = Encoding::UTF_8

FakeWeb.register_uri(:get,
  "https://api.bol.com/catalog/v4/search/?q=harry&apikey=AFF492148CFC4491B29E53C183B05BF2&format=json",
  body: File.read("spec/fakeweb_responses/search.json"))

FakeWeb.register_uri(:get,
  "https://api.bol.com/catalog/v4/lists/?apikey=40E2DCA27B6C4027B5DED2DCC2ACEF20&format=json&dataoutput=products&ids=12&limit=100",
  body: File.read("spec/fakeweb_responses/search.json"))
