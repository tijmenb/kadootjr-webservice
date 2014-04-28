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
        mobile_url: affillize_url(product['mobile_url']),
        desktop_url: affillize_url(product['desktop_url']),
        image_url: product['image'],
      }
    end
  end

  def all_products
    selected_products
  end

  private

  def selected_products
    raw_products.flatten.select do |product|
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

  def combined_key
    "kadootjr-group:#{group_id}:combined"
  end

  def category_ids
    Group.all.find { |g| g['id'].to_s == group_id }['categories']
  end

  def affillize_url(url)
    partner_id = 21278
    url_encoded_url = URI.escape(url).gsub(":", "%3A")
    "http://partnerprogramma.bol.com/click/click?p=1&t=url&s=#{partner_id}&url=#{url_encoded_url}&f=TXL"
  end
end
