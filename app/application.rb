require 'dotenv'
Dotenv.load

require 'sinatra'
require 'json'
require 'sinatra/json'

require './lib/group'
require './lib/product_list'
require './lib/swipe_creator'
require './config/configuration'
require './app/helpers'

get '/' do
  json(lists_url: "http://#{request.host}:#{request.port}/lists")
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
  json ProductList.new(list_id).paginated_products(params['page'] || 0)
end

post '/swipes' do
  swipe =  JSON.parse(request.body.read)
  SwipeCreator.new(swipe).create
  json(message: 'OK')
end

get '/admin' do
  protected!
  erb :admin_dashboard, layout: :admin
end

get '/admin/lists/:list_id' do |list_id|
  protected!
  @list_id = list_id
  @products = ProductList.new(list_id).all_products.take((params['limit'] || 25).to_i)
  erb :list, layout: :admin
end
