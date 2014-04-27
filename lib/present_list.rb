# Maak van de cached Bol API results een
# nice list voor de iOS app.
class PresentList

  attr_reader :group_id

  def initialize(group_id)
    @group_id = group_id
  end

  def presents(page)
    page = page.to_i
    start = page * 10
    ending = start + 9

    selected_products[start..ending].reverse
  end

  def all_products
    selected_products
  end

  private

  def selected_products
    products.flatten.select do |product|
      ProductIncludePolicy.new(product).includeable?
    end
  end

  def products
    combined_key = "kadootjr-group:#{group_id}:combined"
    Redis.current.zunionstore(combined_key,
      ["kadootjr-group:#{group_id}:swipe_popularity",
      "kadootjr-group:#{group_id}:ratings"])

    product_ids = Redis.current.zrevrange(combined_key, 0, -1).to_a
    product_ids.map do |product_id|
      Redis.current.hgetall("kadootjr:product:#{product_id}")
    end
  end

  def category_ids
    Group.all.find { |g| g['id'].to_s == group_id }['categories']
  end

  # def affillize_url(url)
  #   partner_id = 21278
  #   url_encoded_url = URI.escape(url).gsub(":", "%3A")
  #   "http://partnerprogramma.bol.com/click/click?p=1&t=url&s=#{partner_id}&url=#{url_encoded_url}&f=TXL"
  # end
end
