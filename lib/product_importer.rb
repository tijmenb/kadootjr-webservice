require 'redis'
require 'json'

# Importeer een Bol.com categorie in Redis
class ProductImporter
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def add_or_update_products(all_products)
    Redis.current.pipelined do
      all_products.each do |product|
        add_or_update_product(product)
      end
    end
  end

  private

  def add_or_update_product(product)
    Redis.current.mapped_hmset("kadootjr:product:#{product.id}", product.as_json)
    Redis.current.zadd("kadootjr-group:#{group}:ratings", (product.rating.to_i / 10), product.id)
  end
end
