require 'active_support/all'

module BolAPI
  class Product
    EASY_ATTRIBUTES = %w[id title subtitle summary rating short_description]

    attr_accessor *EASY_ATTRIBUTES

    attr_reader :desktop_url, :mobile_url, :images,
      :price, :availability_description, :available, :product_type

    # Initialize with a hash from the API
    def initialize(data)
      EASY_ATTRIBUTES.each do |attr|
        instance_variable_set("@#{attr}", data[attr.camelize(:lower)])
      end

      @desktop_url = value_for_key(data['urls'], 'DESKTOP')
      @mobile_url = value_for_key(data['urls'], 'MOBILE')

      if data['images']
        large_image_key = data['images'].find { |url| url['key'] == 'XL' }
        large_image_url = large_image_key ? large_image_key['url'] : nil

        @images = {
          extra_large: large_image_url
        }
      end

      @product_type = data['gpc']

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

    private

    def value_for_key(array, key)
      array.find { |url| url['key'] == key }['value']
    end
  end
end
