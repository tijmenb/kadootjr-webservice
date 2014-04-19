# Maak van de cached Bol API results een
# nice list voor de iOS app.
class PresentList

  MINIMUM_PRICE = 10
  MAXIMUM_PRICE = 50
  MINIMUM_RATING = 40

  attr_reader :group_id

  def initialize(group_id)
    @group_id = group_id
  end

  def presents
    products.flatten.select do |product|
      product['available'] &&
      !product['rating'].nil? &&
      product['rating'] > MINIMUM_RATING &&
      product['price'] > MINIMUM_PRICE &&
      product['price'] < MAXIMUM_PRICE
    end.shuffle
  end

  private

  def products
    category_ids.map do |category_id|
      JSON.load(File.open("data/#{category_id}.json"))
    end
  end

  def category_ids
    Group.all.find { |g| g['id'].to_s == group_id }['categories']
  end
end
