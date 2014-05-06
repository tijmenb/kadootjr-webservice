require './lib/product_include_policy'

class ProductList
  PER_PAGE = 25

  attr_reader :group_id

  def initialize(group_id)
    @group_id = group_id
  end

  def paginated_products(page)
    page = page.to_i
    start = page * PER_PAGE
    ending = start + PER_PAGE-1

    selected_products[start..ending].to_a.reverse.map do |product|
      { id: product['id'],
        title: product['title'],
        description: product['short_description'],
        price: product['price'].to_f,
        url: shortlink_url(product['id']),
        image_url: product['image']
      }
    end
  end

  def all_products
    selected_products
  end

  def ignored_products
    raw_products.flatten.reject do |product|
      ProductIncludePolicy.new(product).includeable?
    end
  end

  private

  def selected_products
    raw_products.flatten
    # raw_products.flatten.select do |product|
    #   ProductIncludePolicy.new(product).includeable?
    # end
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
