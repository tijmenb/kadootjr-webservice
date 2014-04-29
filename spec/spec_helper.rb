ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'fakeweb'
require 'redis'
require 'rack/test'

Redis.current.select 4

FakeWeb.allow_net_connect = false
Encoding.default_external = Encoding::UTF_8

FakeWeb.register_uri(:get,
  "https://api.bol.com/catalog/v4/search/?q=harry&apikey=AFF492148CFC4491B29E53C183B05BF2&format=json&includeattributes=1",
  body: File.read("spec/fakeweb_responses/search.json"))

FakeWeb.register_uri(:get,
  "https://api.bol.com/catalog/v4/lists/?apikey=XXX&format=json&dataoutput=products&ids=1&limit=25&includeattributes=1",
  body: File.read("spec/fakeweb_responses/search.json"))
