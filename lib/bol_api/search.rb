require 'json'

module BolAPI
  module Search
    def search(args)
      response = HTTParty.get('https://api.bol.com/catalog/v4/lists/', query: query_for(args))
      parsed = JSON.parse(response.body)

      raise_api_error(response) unless response.code == 200
      objectify_products(parsed['products'])
    end

    private

    def query_for(args)
      default_parameters.merge(
        ids: (args[:category_ids] || []).join(','),
        limit: 25,
        includeattributes: 1,
        sort: 'rankdesc')
    end

    def default_parameters
      { apikey: api_key,
        format: 'json',
        dataoutput: 'products' }
    end

    def raise_api_error(response)
      case response.code
      when 400..600
        raise ApiError, "Server responded with #{response.code}: '#{parsed['message']}'"
      end
    end

    def objectify_products(product_hashes)
      return [] if product_hashes.nil?
      product_hashes.map { |product_data| Product.new(product_data) }
    end
  end

  class ApiError < StandardError
  end
end
