# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe GameBoard do
  let(:gameboard) { described_class.new }

  describe '#find_win_combination' do
    context 'when there is a win combination' do
      it do
        board = Array.new(9, 'X')
        gameboard = described_class.new(board)
        expect(gameboard.find_win_combination('X')).to be_an_instance_of(Array)
      end
    end

    context 'when there is not a win combination' do
      it { expect(gameboard.find_win_combination('X')).to be_nil }
    end
  end

  describe '#place_marker' do
    context 'when a valid position argument is passed' do
      it { expect(gameboard.place_marker(0, 'X')).to eq('X') }
    end

    context 'when a invalid position argument is passed' do
      it { expect { gameboard.place_marker(55, 'X') }.to raise_error(ArgumentError, 'Invalid position') }
    end
  end
end
