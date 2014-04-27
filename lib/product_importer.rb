require 'redis'
require 'json'

require './lib/group'

class ProductImporter
  def import
    Encoding.default_external = Encoding::UTF_8

    Group.all.each do |group|
      group['categories'].each do |category_id|
        products = JSON.load(File.open "tmp/cache/#{category_id}.json")
        products.each do |product|
          add_or_update_product(product, group['id'])
        end
      end
    end
  end

  def add_or_update_product(product, group_id)
    id = product['id']
    Redis.current.mapped_hmset("kadootjr:product:#{id}", product)

    unless Redis.current.zscore("kadootjr:group:#{group_id}", id)
      Redis.current.zadd("kadootjr-group:#{group_id}:swipe_popularity", 0, id)
      Redis.current.zadd("kadootjr-group:#{group_id}:ratings", product['rating'], id)
    end
  end
end
