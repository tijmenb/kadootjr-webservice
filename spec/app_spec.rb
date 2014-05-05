require 'spec_helper'
require './app/application'

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

describe 'GET /v1/lists' do
  it "it returns an array of groups" do
    get '/v1/lists'
    expect(response_data).to be_a(Array)
  end
end

describe "GET /v1/lists" do
  it "returns presents from Bol.com" do
    get '/v1/lists/1'
    expect(response_data).to be_a(Array)
  end
end

describe "POST /v1/swipes" do
  it "saves the swipe to Redis" do
    post '/v1/swipes', JSON.dump({ swipes: ['group_id' => 1] })
    expect(response_data).to eq("message"=>"OK")
  end
end
