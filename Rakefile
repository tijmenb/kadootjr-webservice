require 'dotenv'
Dotenv.load

require './lib/product_importer'

desc 'Importeer Bol.com category naar Redis'
task :import_category do
  ProductImporter.new(category: ENV['CATEGORY'], group: ENV['GROUP']).import
end
