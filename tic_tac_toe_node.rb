require_relative 'tic_tac_toe'
require 'byebug'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if board.over?
      return board.winner != evaluator && board.won?
    end
    if @next_mover_mark == evaluator
      children.all? { |node| node.losing_node?(evaluator) }
    else
      children.any? { |node| node.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    if board.over?
      return (board.winner == evaluator ? true : false)
    end
    if @next_mover_mark == evaluator
      children.any? { |node| node.winning_node?(evaluator) }
    else
      children.all? { |node| node.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    result = []
    @next_mover_mark = (next_mover_mark == :x ? :o : :x)
    board.rows.each_with_index do |row, r_idx|
      row.each_with_index do |_, c_idx|
        if board.empty?([r_idx, c_idx])
          new_board = board.dup
          new_board[[r_idx, c_idx]] = next_mover_mark
          @prev_move_pos = [r_idx, c_idx]

          result << TicTacToeNode.new(new_board, next_mover_mark, prev_move_pos)
        end
      end
    end

    result
  end
end
