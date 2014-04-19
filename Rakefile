require 'dotenv'
Dotenv.load

require 'json'
require './lib/group'
require './lib/bol_api'

desc 'Download products from Bol and save them to S3'
task :download_products do
  Group.all.each do |group|
    group['categories'].each do |category_id|
      puts "Downloading: category ##{category_id}..."
      products = BolAPI::Client.new(ENV['BOL_KEY']).search(category_ids: [category_id])
      json_data = JSON.dump(products.as_json)
      File.open("data/#{category_id}.json", "w") { |f| f.write(json_data) }
    end
  end
end
