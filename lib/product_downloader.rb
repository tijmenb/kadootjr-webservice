require 'json'
require './lib/bol_api'

# Importeer een Bol.com categorie in Redis
class ProductDownloader
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def products(category)
    bol_client.search(category_ids: [category])
  end

  private

  def bol_client
    @bol_client ||= BolAPI::Client.new(ENV['BOL_KEY'])
  end
end
