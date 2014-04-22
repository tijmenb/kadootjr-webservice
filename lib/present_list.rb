# Maak van de cached Bol API results een
# nice list voor de iOS app.
class PresentList

  attr_reader :group_id

  def initialize(group_id)
    @group_id = group_id
  end

  def presents(page)
    page = page.to_i
    start = page * 10
    ending = start + 9

    selected_products[start..ending].reverse
  end

  private

  def selected_products
    products.flatten.select do |product|
      ProductIncludePolicy.new(product).includeable?
    end
  end

  def products
    category_ids.map do |category_id|
      begin
        JSON.load(File.open("data/products/#{category_id}.json"))
      rescue Errno::ENOENT
        puts "No file named #{category_id}"
        [] # soms bestaan dingen niet
      end
    end
  end

  def category_ids
    Group.all.find { |g| g['id'].to_s == group_id }['categories']
  end
end
