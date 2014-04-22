ENV['RACK_ENV'] = 'test'

require './app'
require 'rspec'
require 'fakeweb'
require 'rack/test'

FakeWeb.allow_net_connect = false
Encoding.default_external = Encoding::UTF_8

FakeWeb.register_uri(:get,
  "https://api.bol.com/catalog/v4/search/?q=harry&apikey=AFF492148CFC4491B29E53C183B05BF2&format=json",
  body: File.read("spec/fakeweb_responses/search.json"))

module Helpers
  def app
    Sinatra::Application
  end

  def response_data
    JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Helpers
end

describe 'GET /lists' do
  it "it returns an array of groups" do
    get '/lists'
    expect(response_data).to be_a(Array)
  end
end

describe "GET /groups/:id/presents" do
  it "returns presents from Bol.com" do
    get '/lists/1'
    expect(response_data).to be_a(Array)
  end

  it "returns a page from the product lists" do
    get '/lists/1?page=1'
    expect(response_data.count).to eq 10
  end
end
