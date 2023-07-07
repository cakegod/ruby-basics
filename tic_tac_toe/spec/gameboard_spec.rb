# frozen_string_literal: true

require_relative '../lib/index'
require 'rspec'

describe GameBoard do
  describe '#find_win_combination' do
    context 'when there is a win combination' do
      subject(:gameboard) { described_class.new(Array.new(9, 'X')) }
      it { expect(gameboard.find_win_combination('X')).to be_an_instance_of(Array) }
    end

    context 'when there is not a win combination' do
      subject(:gameboard) { described_class.new }
      it { expect(gameboard.find_win_combination('X')).to be_nil }
    end
  end

  describe '#place_marker' do
    context 'when a valid position argument is passed' do
      subject { described_class.new.place_marker(0, 'X') }
      it { is_expected.to eq('X') }
    end

    context 'when a invalid position argument is passed' do
      subject { described_class.new.place_marker(55, 'X') }
      it { expect { subject }.to raise_error(ArgumentError, 'Invalid position') }
    end
  end
end