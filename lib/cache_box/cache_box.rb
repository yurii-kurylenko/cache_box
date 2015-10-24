module CacheBox
  class CacheBox
    def initialize(coins)
      @coins = coins
    end

    def exchange(exchange_value)
      exchange_value_in_coins = to_coins(exchange_value)
      exchange_result = exchange_coins(exchange_value_in_coins)
      validate_result(exchange_result, exchange_value_in_coins)
      reduce_box_coins(exchange_result)
      exchange_result
    end

    private

    def exchange_coins(exchange_value_in_coins)
      exchange_result = []
      @coins.inject(exchange_value_in_coins) do |acc, coin|
        next acc if coin[:count] == 0
        coins_count = coins_count_for_exchange(acc, coin)
        if coins_count > 0
          exchange_result << { count: coins_count, value: coin[:value] }
        end
        acc - coins_count * coin[:value]
      end
      exchange_result
    end

    def validate_result(result, exchange_value)
      sum  = result.inject(0) { |a, e| a + e[:value] * e[:count] }
      fail CoinsMissingError if sum != exchange_value
    end

    def reduce_box_coins(exchange_result)
      @coins.each do |coin|
        exchange_result.each do |result_coins|
          if coin[:value] == result_coins[:value]
            coin[:count] -= result_coins[:count]
          end
        end
      end
    end

    def to_coins(value)
      value * 100
    end

    def coins_count_for_exchange(acc, coin)
      ceil_coins = (acc.to_f / coin[:value]).ceil
      return 0 if ceil_coins == 0
      (ceil_coins > coin[:count]) ? coin[:count] : ceil_coins
    end
  end
end
