require 'dotenv'
Dotenv.load

require 'sinatra'
require 'json'
require 'sinatra/json'

require 'redis'

require './lib/group'
require './lib/present_list'
require './lib/product_include_policy'

get '/' do
  data = { lists_url: "http://#{request.host}:#{request.port}/lists" }
  json data
end

get '/lists' do
  data = Group.all.map do |group|
    { id: group['id'].to_s,
      name: group['name'],
      url: "http://#{request.host}:#{request.port}/lists/#{group['id']}" }
  end

  json data
end

get '/lists/:list_id' do |list_id|
  json PresentList.new(list_id).presents(params['page'] || 0)
end

get '/admin/lists/:list_id' do |list_id|
  @products = PresentList.new(list_id).all_products
  erb :list
end
