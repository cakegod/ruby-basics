# frozen_string_literal: true

require 'rspec'
require_relative '../lib/main'

describe Column do
  let(:column) { described_class.new }

  describe '#initiaze' do
    describe 'when initialized' do
      it 'has empty rows' do
        expect(column.rows).to eql(Array.new(NUMBER_OF_ROWS, ''))
      end
    end
  end

  describe '#place_marker' do
    context 'when called' do
      it 'places pieces from the bottom up' do
        (NUMBER_OF_ROWS - 1).times do |i|
          column.place_marker('x')
          expect(column.rows[i]).to eql('x')
        end
      end
      it 'raises an error when the column is full' do
        NUMBER_OF_ROWS.times { column.place_marker('x') }
        expect { column.place_marker('x') }.to raise_error('column is full')
      end
    end

    context 'with other than "x" marker placement' do
      it 'places different types of pieces' do
        column.place_marker('o')
        expect(column.rows.first).to eq('o')
      end
    end

    context 'when column has only one slot filled' do
      it 'places the next piece above the last' do
        column.place_marker('x')
        column.place_marker('o')
        expect(column.rows[1]).to eq('o')
      end
    end
  end

  describe '#check_vertical' do
    context 'when there is a win combination' do
      it 'returns the win combination' do
        marker = 'x'
        4.times { |_| column.place_marker(marker) }
        expect(column.check_vertical(marker)).to eq([0, 1, 2, 3])
      end
    end
  end
end

describe GameBoard do
  let(:gameboard) { described_class.new }

  describe '#initiaze' do
    describe 'when initialized' do
      it 'has Columns' do
        expect(gameboard.board).to all(be_a(Column))
        gameboard.board.each do |column|
          expect(column.rows).to eql(Array.new(NUMBER_OF_ROWS, ''))
        end
      end
    end
  end

  describe '#place_marker' do
    context 'when called' do
      it 'places a marker in a specified column' do
        gameboard.place_marker(0, 'x')
        expect(gameboard.board[0].rows.first).to eq('x')
      end

      it 'places different types of markers' do
        gameboard.place_marker(0, 'o')
        expect(gameboard.board[0].rows.first).to eq('o')
      end

      it "calls Column' #place_marker" do
        spy_column = spy('column')
        gameboard = described_class.new(board: Array.new(NUMBER_OF_COLUMNS) { spy_column })

        gameboard.place_marker(0, 'x')
        expect(spy_column).to have_received(:place_marker).with('x')
      end

      it 'raises an error for an invalid column' do
        invalid_column = 9
        expect do
          gameboard.place_marker(invalid_column, 'x')
        end.to raise_error(ArgumentError, "invalid column (given #{invalid_column} , expected value between (0 and 6))")
      end
    end

    describe '#check_win' do
      context 'when a horizontal win exists' do
        it 'returns the win indexes' do
          marker = 'x'
          4.times { |i| gameboard.place_marker(i, marker) }
          expect(gameboard.check_win(marker)).to eq([[0, 0], [1, 0], [2, 0], [3, 0]])
        end
      end
    end
  end
end
