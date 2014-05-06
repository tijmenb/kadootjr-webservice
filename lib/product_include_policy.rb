require 'yaml'

class ProductIncludePolicy
  attr_reader :product

  BAD_WORDS = YAML.load_file("config/banned_words.yml")
  MINIMUM_PRICE = 5
  MINIMUM_RATING = 1

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
    !product['rating'].nil? && product['rating'].to_i > MINIMUM_RATING
  end

  def price_okay?
    product['price'].to_i > MINIMUM_PRICE
  end

  def words_okay?
    BAD_WORDS.none? do |word|
      product['title'].downcase.include? word.downcase
    end
  end
end
