require 'dotenv'
Dotenv.load

require 'pp'
require './lib/kadootjr'

task :deploy do
  `git push && git push heroku master:master && heroku run rake cache:clear`
end

namespace :cache do
  desc 'Clear de cache'
  task :clear do
    Cache.clear
  end
end

desc 'Run console within environment'
task :console do
  require 'pry'
  binding.pry
end

namespace :products do
  desc 'Importeer alle initial categories (duurt lang)'
  task :reset do
    Cache.clear
    Redis.current.flushdb
    ProductSyncer.new.update
  end

  desc 'Update all products'
  task :update do
    Cache.clear
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
