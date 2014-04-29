require 'dotenv'
Dotenv.load

require './lib/product_importer'
require './lib/group'

desc 'Importeer alle initial categories (duurt lang)'
task :import_initial do
  Redis.current.flushdb

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
