require 'dotenv'
Dotenv.load

require 'sinatra'
require 'json'
require 'sinatra/json'

require './lib/cache'
require './lib/group'
require './lib/product_list'
require './lib/swipe_creator'
require './config/configuration'
require './app/helpers'

if ENV['RACK_ENV'] == 'production'
  newrelic_ignore '/admin'
end

get '/' do
  json(lists_url: "http://#{request.host}:#{request.port}/v1/lists")
end

get '/v1/lists' do
  data = Group.all.map do |group|
    { id: group['id'].to_s,
      name: group['name'],
      url: "http://#{request.host}:#{request.port}/v1/lists/#{group['id']}" }
  end

  json data
end

get '/v1/lists/:list_id' do |list_id|
  page_id = (params['page'] || 0).to_i
  per_page = (params['limit'] || 25).to_i
  products = ProductList.new(list_id).paginated_products(page_id, per_page)
  json products
end

post '/v1/swipes' do
  data = JSON.parse(request.body.read)

  Redis.current.pipelined do
    data['swipes'].each do |swipe|
      SwipeCreator.new(swipe).create
    end
  end

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
