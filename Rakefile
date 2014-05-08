require 'dotenv'
Dotenv.load

require 'pp'
require './lib/group'
require './lib/product_syncer'
require './lib/product_list'

namespace :products do
  desc 'Importeer alle initial categories (duurt lang)'
  task :reset do
    Redis.current.flushdb
    ProductSyncer.new.update
  end

  desc 'Update all products'
  task :update do
    group = ENV['GROUP'] || ENV['GROUP_ID']
    if group
      ProductSyncer.new.update_group(group)
    else
      ProductSyncer.new.update
    end
  end

  desc 'List all ignored products'
  task :list_ignored do
    ignored = ProductList.new(ENV['GROUP']).ignored_products.map { |p|
      { p['title'] => p }
    }

    puts "Ignored in category: #{ignored.count}\n"
    puts ignored.join("\n")
  end

  desc 'Download a category'
  task :download do
    category = ENV['CATEGORY']
    products = BolAPI::Client.new(ENV['BOL_KEY']).search(category_ids: [category])
    hashes = products.map do |p|
      [p.id, p.title, p.rating, p.available]
    end

    pp hashes
  end
end
