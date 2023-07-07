# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe Player do
  describe '#initialize' do
    context 'when initialized' do
      subject(:player) { described_class.new('X') }
      it { expect(player.marker).to eq('X') }
    end
  end
end
