require 'spec_helper'
require './app'

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
end

describe "POST /swipes" do
  it "saves the swipe to Redis" do
    post '/swipes', JSON.dump('group_id' => 1)
    expect(response_data).to eq("message"=>"OK")
  end
end
