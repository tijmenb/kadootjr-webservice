require_relative 'search'

module BolAPI
  class Client
    attr_reader :api_key

    include BolAPI::Search

    def initialize(api_key)
      @api_key = api_key
    end
  end
end
