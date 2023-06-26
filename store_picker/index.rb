# frozen_string_literal: true

def stock_picker(prices)
  buy_sell_pairs = (0...prices.length).to_a.combination(2)
  buy_sell_pairs.max_by { |buy, sell| prices[sell] - prices[buy] }
end
