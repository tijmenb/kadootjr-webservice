require 'dotenv'
Dotenv.load

require 'sinatra'
require 'json'
require 'sinatra/json'

require 'bol'

require './lib/initializers'
require './lib/groups'

get '/' do
  json status: 'OK'
end

get '/groups' do
  json Group.all
end
