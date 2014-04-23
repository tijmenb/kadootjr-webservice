class ProductIncludePolicy
  attr_reader :product

  BAD_WORDS = YAML.load_file("configs/banned_words.yml")
  MINIMUM_PRICE = 10
  MAXIMUM_PRICE = 50
  MINIMUM_RATING = 40

  def initialize(product)
    @product = product
  end

  def includeable?
    available? &&
    rating_okay? &&
    price_okay? &&
    words_okay? &&
    true
  end

  private

  def available?
    product['available']
  end

  def rating_okay?
    !product['rating'].nil? &&
    product['rating'] > MINIMUM_RATING
  end

  def price_okay?
    product['price'] > MINIMUM_PRICE &&
    product['price'] < MAXIMUM_PRICE
  end

  def words_okay?
    BAD_WORDS.none? do |word|
      product['title'].downcase.include? word
    end
  end
end
