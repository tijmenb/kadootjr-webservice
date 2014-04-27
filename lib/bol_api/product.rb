require 'active_support/all'
require 'uri'

module BolAPI
  class Product
    EASY_ATTRIBUTES = %w[id title subtitle summary rating short_description]
    OTHER_ATTRIBUTES = [:desktop_url, :mobile_url, :image,
      :price, :availability_description, :available, :product_type]

    attr_accessor *EASY_ATTRIBUTES

    attr_reader *OTHER_ATTRIBUTES
    attr_reader :data

    # Initialize with a hash from the API
    def initialize(data)
      @data = data
      parse_common_attributes
      parse_urls
      parse_images
      parse_offers
    end

    def as_json
      (EASY_ATTRIBUTES + OTHER_ATTRIBUTES).reduce(Hash.new) { |h, key|
        h[key] = self.send(key)
        h
      }
    end

    private

    def parse_common_attributes
      EASY_ATTRIBUTES.each do |attr|
        instance_variable_set("@#{attr}", data[attr.camelize(:lower)])
      end

      @product_type = data['gpc']
    end

    def parse_urls
      @desktop_url = value_for_key(data['urls'], 'DESKTOP')
      @mobile_url = value_for_key(data['urls'], 'MOBILE')
    end

    def parse_images
      return if !data['images']

      large_image_key = data['images'].find { |url| url['key'] == 'XL' }
      large_image_url = large_image_key ? large_image_key['url'] : nil

      @image = large_image_url
    end

    def parse_offers
      if data['offerData'] && data['offerData']['offers']
        # we zijn alleen geinteresseerd in normale bol producten
        bol_offer = data['offerData']['offers'].find { |offer| offer['seller']['id'] == '0' }
        if bol_offer
          @price = bol_offer['price']
          @availability_description = bol_offer['availabilityDescription']
          @available = true
        else
          @available = false
        end
      else
        @available = false
      end
    end

    def value_for_key(array, key)
      array.find { |url| url['key'] == key }['value']
    end
  end
end
