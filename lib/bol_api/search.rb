require 'json'

module BolAPI
  module Search
    def search(args = {})
      query = { apikey: api_key, format: 'json', dataoutput: 'products', limit: 10 }

      if args[:category_ids]
        query.merge! ids: args[:category_ids].join(',')
      end

      response = HTTParty.get('https://api.bol.com/catalog/v4/lists/', query: query)
      parsed = JSON.parse(response.body)

      case response.code
      when 400..600
        raise ApiError, "Server responded with #{response.code}: '#{parsed['message']}'"
      end

      objectify_products(parsed['products'])
    end

    private

    def objectify_products(product_hashes)
      return [] if product_hashes.nil?
      product_hashes.map { |product_data| Product.new(product_data) }
    end
  end

  class ApiError < StandardError
  end
end
