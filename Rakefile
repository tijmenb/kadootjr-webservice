require 'dotenv'
Dotenv.load

require './lib/product_importer'
require './lib/group'

desc 'Importeer Bol.com category naar Redis'
task :import_category do
  ProductImporter.new(category: ENV['CATEGORY'], group: ENV['GROUP']).import
end

desc 'Importeer alle initial categories (duurt lang)'
task :import_initial do
  Group.all.each do |group|
    group['categories'].each do |category_id|
      puts "Downloading #{category_id} for #{group['name']}"
      ProductImporter.new(category: category_id, group: group['id']).import
    end
  end
end
