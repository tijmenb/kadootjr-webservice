
require './lib/group'

require './lib/bol_api'

class ProductDownloader
  def download
    categories.each do |category_id|
      CategoryDownloader.new(category_id).download
    end
  end

  private

  def categories
    Group.all.map { |group| group['categories'] }.flatten.uniq
  end
end

class CategoryDownloader
  attr_reader :category_id

  def initialize(category_id)
    @category_id = category_id
  end

  def download
    begin
      filename = "tmp/cache/#{category_id}.json"
      if File.exists?(filename)
        return
      end

      if products.nil?
        puts "Search for #{category_id} is empty."
        return
      end

      json_data = JSON.dump(products.map(&:as_json))
      puts "Saving #{filename}..."
      File.open(filename, "w") { |f| f.write(json_data) }
    rescue StandardError => e
      puts "#{e.inspect}"
      puts "Products:"
      puts products.inspect
    end
  end

  def products
    @products ||= bol_client.search(category_ids: [category_id])
  end

  def bol_client
    @bol_client ||= BolAPI::Client.new(ENV['BOL_KEY'])
  end
end
