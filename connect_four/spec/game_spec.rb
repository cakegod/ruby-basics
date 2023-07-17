# frozen_string_literal: true

require 'rspec'
require_relative '../lib/main'

describe Column do
  let(:column) { described_class.new }
  let(:number_of_rows) { Column::NUMBER_OF_ROWS }

  describe '#place_marker' do
    context 'when a marker is placed' do
      it 'does not raise an error until column is filled up' do
        expect do
          number_of_rows.times { column.place_marker('x') }
        end.not_to raise_error
      end

      it 'raises an error when the column is full' do
        number_of_rows.times { column.place_marker('x') }
        expect { column.place_marker('x') }.to raise_error('column is full')
      end
    end
  end

  describe '#check_vertical' do
    context 'when there is a win combination' do
      it 'returns the win combination' do
        marker = 'x'
        4.times { column.place_marker(marker) }
        expect(column.check_vertical(marker)).to eq([2, 3, 4, 5])
      end
    end
  end

  describe '#check_vertical' do
    context 'when there is not a win combination' do
      it 'returns nil' do
        marker = 'x'
        3.times { column.place_marker(marker) }
        expect(column.check_vertical(marker)).to be_nil
      end
    end
  end
end

describe GameBoard do
  let(:gameboard) { described_class.new }
  let(:marker) { 'x' }

  describe '#place_marker' do
    context 'when a marker is placed in each column' do
      it 'does not raise an error until column is filled up' do
        (0...NUMBER_OF_COLUMNS).each do |column|
          expect { gameboard.place_marker(column, 'x') }.not_to raise_error
        end
      end
    end

    context 'when placing a marker in a full column' do
      it 'raises an error' do
        column = 0
        (0...Column::NUMBER_OF_ROWS).each do |_|
          gameboard.place_marker(column, 'x')
        end

        expect { gameboard.place_marker(column, 'x') }.to raise_error('column is full')
      end
    end

    it 'calls collaborator #place_marker' do
      spy_column = spy('column')
      gameboard = described_class.new(board: Array.new(NUMBER_OF_COLUMNS) { spy_column })

      gameboard.place_marker(0, marker)
      expect(spy_column).to have_received(:place_marker).with(marker)
    end

    context 'when an invalid column is used' do
      it 'raises an error' do
        invalid_column = 9

        expect do
          gameboard.place_marker(invalid_column, marker)
        end.to raise_error(ArgumentError, "invalid column (given #{invalid_column} , expected value between (0 and 6))")
      end
    end

    describe '#check_win' do
      context 'when a horizontal win exists' do
        it 'returns the win indexes' do
          4.times { |i| gameboard.place_marker(i, marker) }
          expect(gameboard.check_win(marker)).to be_truthy
        end
      end
    end
  end
end
