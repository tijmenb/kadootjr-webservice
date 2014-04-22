require 'dotenv'
Dotenv.load

require 'json'
require './lib/group'
require './lib/bol_api'

desc 'Download products from Bol and save them to S3'
task :download_products do

  categories = Group.all.map { |group| group['categories'] }.flatten.uniq
  categories.each do |category_id|
    if File.exists?("data/#{category_id}.json")
      puts "Skipping: category ##{category_id}..."
      next
    else
      puts "Downloading: category ##{category_id}..."
    end

    begin
      products = BolAPI::Client.new(ENV['BOL_KEY']).search(category_ids: [category_id])
      if products.nil?
        puts "Search for #{category_id} is empty."
        next
      end

      json_data = JSON.dump(products.as_json)
      File.open("data/#{category_id}.json", "w") { |f| f.write(json_data) }
    rescue StandardError => e
      puts "#{e.inspect}"
      puts "Products:"
      puts products.inspect
    end

  end
end
