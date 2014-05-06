require 'dotenv'
Dotenv.load

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
end
