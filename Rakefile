require 'dotenv'
Dotenv.load

require './lib/group'
require './lib/product_syncer'

namespace :products do
  desc 'Importeer alle initial categories (duurt lang)'
  task :reset do
    Redis.current.flushdb
    ProductSyncer.new.update
  end

  desc 'Update all products'
  task :update do
    ProductSyncer.new.update
  end

  desc 'Update a group'
  task :update_group do
    ProductSyncer.new.update_group(ENV['GROUP'] || ENV['GROUP_ID'])
  end

  desc 'List all ignored products'
  task :list_ignored do
    ignored = ProductList.new(ENV['GROUP']).ignored_products.map { |p|
      p['title'] + " - " + p['rating'] + " - " + p['available'] + " - " + p['price']
    }

    puts "Ignored in category: #{ignored.count}\n"
    puts ignored.join("\n")
  end
end
