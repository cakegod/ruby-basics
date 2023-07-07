# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe Player do
  describe '#initialize' do
    context 'when initialized' do
      it do
        marker = 'X'
        player = described_class.new(marker)
        expect(player.marker).to eq('X')
      end
    end
  end
end

