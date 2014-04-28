require 'dotenv'
Dotenv.load

require 'sinatra'
require 'json'
require 'sinatra/json'

require 'redis'

require './lib/group'
require './lib/product_list'

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
  json ProductList.new(list_id).products(params['page'] || 0)
end

# Sla de swipe op in de database
post '/swipes' do
  swipe =  JSON.parse(request.body.read)
  score_change = swipe['direction'] == 'added' ? 1 : -1
  Redis.current.zincrby("kadootjr-group:#{swipe['group_id']}:swipe-popularity", score_change, swipe['product_id'])
  Redis.current.zincrby("kadootjr-group:#{swipe['group_id']}:swipe-#{swipe['direction']}", 1, swipe['product_id'])
  json({message: 'OK'})
end

get '/admin/lists/:list_id' do |list_id|
  @list_id = list_id
  @products = ProductList.new(list_id).all_products.take(150)
  erb :list
end

get '/admin' do
  erb :admin
end
