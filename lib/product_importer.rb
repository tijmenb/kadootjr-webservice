require 'redis'
require 'json'

require './lib/bol_api'

# Importeer een Bol.com categorie in Redis
class ProductImporter
  attr_reader :category, :group

  def initialize(category: category, group: group)
    @category = category
    @group = group
  end

  def import
    products.each do |product|
      add_or_update_product(product)
    end
  end

  private

  def add_or_update_product(product)
    Redis.current.mapped_hmset("kadootjr:product:#{product.id}", product.as_json)
    Redis.current.zadd("kadootjr-group:#{group}:ratings", product.rating, product.id)
  end

  def products
    @products ||= bol_client.search(category_ids: [category])
  end

  def bol_client
    @bol_client ||= BolAPI::Client.new(ENV['BOL_KEY'])
  end
end
