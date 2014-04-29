require 'redis'
require 'json'

require './lib/bol_api'

# Importeer een Bol.com categorie in Redis
class ProductImporter
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def products(category)
    bol_client.search(category_ids: [category])
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

  def bol_client
    @bol_client ||= BolAPI::Client.new(ENV['BOL_KEY'])
  end
end
