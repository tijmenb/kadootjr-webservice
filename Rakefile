require 'dotenv'
Dotenv.load

require './lib/product_importer'
require './lib/group'
require './lib/product_list'

desc 'Importeer alle initial categories (duurt lang)'
task :import_initial do
  Group.all.map do |group|
    importer = ProductImporter.new(group['id'])

    products = group['categories'].map do |category_id|
      puts "Downloading ##{category_id} (#{group['name']}) from Bol.com"
      importer.products(category_id)
    end.flatten.uniq.shuffle

    puts "Putting #{products.size} products in de database"
    importer.add_or_update_products(products)
  end
end

task :ignored_products do
  ignored = ProductList.new(ENV['GROUP']).ignored_products.map { |p|
    p['title'] + " - " + p['rating'] + " - " + p['available'] + " - " + p['price']
  }

  puts "Ignored in category: #{ignored.count}\n"
  puts ignored.join("\n")
end
