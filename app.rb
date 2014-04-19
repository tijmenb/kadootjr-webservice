require 'dotenv'
Dotenv.load

require 'sinatra'
require 'json'
require 'sinatra/json'

require './lib/group'
require './lib/present_list'

get '/' do
  json status: 'OK'
end

get '/lists' do
  json Group.all
end

get '/lists/:list_id' do |list_id|
  json PresentList.new(list_id).presents
end
