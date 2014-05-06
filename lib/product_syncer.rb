require './lib/product_downloader'
require './lib/product_importer'
require './lib/group'

class ProductSyncer
  def update
    Group.all.map do |group|
      update_group(group)
    end
  end

  def update_group(group_id)
    downloader = ProductDownloader.new(group_id)
    group = Group.find(group_id)

    products = group['categories'].map do |category_id|
      puts "Downloading ##{category_id} (#{group_id}) from Bol.com"
      downloader.products(category_id)
    end.flatten.uniq.shuffle

    importer = ProductImporter.new(group_id)
    puts "Putting #{products.size} products in de database"

    if products.size > 0
      importer.add_or_update_products(products)
    end
  end
end
