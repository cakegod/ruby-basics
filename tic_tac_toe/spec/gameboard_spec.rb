# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe GameBoard do
  subject(:gameboard) { board ? described_class.new(board) : described_class.new }

  describe '#find_win_combination' do
    context 'when there is a win combination' do
      let(:board) { Array.new(9, 'X') }
      it { expect(gameboard.find_win_combination('X')).to be_an_instance_of(Array) }
    end

    context 'when there is not a win combination' do
      let(:board) {}
      it { expect(gameboard.find_win_combination('X')).to be_nil }
    end
  end

  describe '#place_marker' do
    context 'when a valid position argument is passed' do
      let(:board) {}
      it { expect(gameboard.place_marker(0, 'X')).to eq('X') }
    end

    context 'when a invalid position argument is passed' do
      let(:board) {}
      it { expect { gameboard.place_marker(55, 'X') }.to raise_error(ArgumentError, 'Invalid position') }
    end
  end
end
