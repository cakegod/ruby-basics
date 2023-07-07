# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe PlayersManager do
  subject(:player_manager) { described_class.new }

  describe '#current_marker' do
    context 'when called' do
      it { expect(player_manager.current_player_marker).to eq('X') }
    end

    context 'when called after swapping player' do
      it do
        player_manager.swap_player
        expect(player_manager.current_player_marker).to eq('O')
      end
    end
  end
end
