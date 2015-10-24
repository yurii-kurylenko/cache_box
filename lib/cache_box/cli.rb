module CacheBox
  class CLI
    def run
      p 'CacheBox App has been started!. Press q to exit'
      p 'Please, insert coins to the cache box'
      cache_box = CacheBox.new(insert_coins)
      p 'Cache box initalized!'
      p 'Now you can perform exchange'
      while true
        p 'Amount for exchange: '
        value = gets.chomp
        break if value == 'q'
        begin
          format_result(cache_box.exchange(value.to_i))
        rescue CoinsMissingError => e
          p "Coints missing for this amount"
        end
      end
    end

    private

    def format_result(result)
      p "Result:"
      result.each do |coin|
        p "#{coin[:count]} with value #{coin[:value]}"
      end
    end

    def insert_coins
      coins_for_insert = []
      Coin::AVAILABLE_COIN_VALUES.each do |value|
        coins_for_insert << insert_coins_with_value(value)
      end
      coins_for_insert
    end

    def insert_coins_with_value(value)
      p "Count of coins with value: #{value}"
      count = gets.to_i
      { count: count, value: value }
    end
  end
end
