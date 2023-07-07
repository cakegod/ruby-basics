# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe Player do
  subject(:player) { described_class.new(marker) }

  describe '#initialize' do
    context 'when initialized' do
      let(:marker) { 'X' }
      it { expect(player.marker).to eq('X') }
    end
  end
end
