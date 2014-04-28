require 'redis'

class SwipeCreator
  attr_reader :swipe

  def initialize(swipe)
    @swipe = swipe
  end

  def create
    Redis.current.zincrby("kadootjr-group:#{swipe['group_id']}:swipe-popularity", score_change, swipe['product_id'])
    Redis.current.zincrby("kadootjr-group:#{swipe['group_id']}:swipe-#{swipe['direction']}", 1, swipe['product_id'])
  end

  private

  def score_change
    swipe['direction'] == 'added' ? 1 : -1
  end
end
