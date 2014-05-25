require './lib/product_include_policy'

class ProductList
  attr_reader :group_id

  def initialize(group_id)
    @group_id = group_id
  end

  def paginated_products(page, per_page)
    start, ending = paging(page, per_page)

    selected_products[start..ending].map do |product|
      { id: product['id'],
        title: product['title'],
        description: product['short_description'],
        price: product['price'].to_f,
        url: shortlink_url(product['id']),
        image_url: product['image']
      }
    end
  end

  def paging(page, items_per_page)
    start  = page * items_per_page
    ending = start + items_per_page - 1
    [start, ending]
  end

  def all_products
    selected_products
  end

  def ignored_products
    raw_products.flatten.reject do |product|
      ProductIncludePolicy.new(product).includeable?
    end
  end

  def raw_products
    Redis.current.zunionstore(combined_key,
      ["kadootjr-group:#{group_id}:swipe-popularity",
       "kadootjr-group:#{group_id}:ratings"])

    product_ids = Redis.current.zrevrange(combined_key, 0, -1).to_a
    product_ids.map do |product_id|
      Redis.current.hgetall("kadootjr:product:#{product_id}")
    end
  end

  private

  def selected_products
    Cache.fetch(["product-list", group_id]) do
      raw_products.flatten.select do |product|
        ProductIncludePolicy.new(product).includeable?
      end
    end
  end

  def combined_key
    "kadootjr-group:#{group_id}:combined"
  end

  def category_ids
    Group.all.find { |g| g['id'].to_s == group_id }['categories']
  end

  def shortlink_url(product_id)
    id = product_id.to_i.to_s(36)
    "http://tips.kadootjr.nl/#{id}"
  end
end
