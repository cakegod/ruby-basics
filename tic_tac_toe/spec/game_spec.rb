# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe Game do
  subject(:game) { described_class.new(input: input) }

  describe '#game_loop' do
    context 'with a predefined input sequence resulting in a win' do
      input_sequence = %w[0 4 1 6 2]
      let(:input) { -> { input_sequence.shift } }
      it { expect { game.game_loop }.to output(/Player X wins at \[0, 1, 2\]/).to_stdout }
    end
  end
end
