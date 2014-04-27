require 'dotenv'
Dotenv.load

require 'json'
require './lib/product_downloader'
require './lib/product_importer'

desc 'Download products from Bol'
task :download_products do
  ProductDownloader.new.download
end

desc 'Import products naar Redis'
task :import do
  ProductImporter.new.import
end

desc 'Import initial'
task :initial do
  ProductDownloader.new.download
  ProductImporter.new.import
end
