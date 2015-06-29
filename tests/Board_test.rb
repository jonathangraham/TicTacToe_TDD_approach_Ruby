require_relative '../lib/Board'
require 'minitest/autorun'

def replace_initial_board_for_tests(board, test_board)
	test_board.each_with_index do |e, i|
		board.update_board(i, e)
	end
end

class TestBoard < Minitest::Test

	def test_create_new_board_3x3
		board = Board.new(3, 3)
		assert_equal([' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '], board.board)
	end

	def test_create_new_board_4x4
		board = Board.new(4, 4)
		assert_equal([' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '], board.board)
	end

	def test_create_new_index_board_3x3
		board = Board.new(3, 3)
		assert_equal([0,1,2,3,4,5,6,7,8], board.index_board)
	end

	def test_update_board
		board = Board.new(3, 3)
		board.update_board(2, 'X')
		assert_equal([' ', ' ', 'X', ' ', ' ', ' ', ' ', ' ', ' '], board.board)
	end

	def test_board_with_spaces_and_no_win_returns_false_for_game_end?
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', ' ', 'O', 'X', ' ', ' ', ' ', ' ', ' '])
		assert_equal(false, board.game_end?)
	end

	def test_full_board_without_win_returns_true_with_game_end?
		board = Board.new(3, 3) 
		replace_initial_board_for_tests(board, ['X', 'X', 'O', 'O', 'O', 'X', 'X', 'O', 'X'])
		assert_equal(true, board.game_end?)
	end

	def test_empty_board_returns_false_for_X_win?
		board = Board.new(4, 4)
		assert_equal(false, board.win?('X'))
	end

	def test_3_in_row_winning_board_for_X_returns_true_for_X_win?
		board = Board.new(3, 3) 
		replace_initial_board_for_tests(board, ['X', 'X', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal(true, board.win?('X'))
	end

	def test_2_in_row_winning_board_for_X_returns_true_for_X_win?
		board = Board.new(3, 2) 
		replace_initial_board_for_tests(board, ['O', 'X', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal(true, board.win?('X'))
	end

	def test_2_in_left_diagonal_row_winning_board_for_X_returns_true_for_X_win?
		board = Board.new(3, 2) 
		replace_initial_board_for_tests(board, [' ', 'X', 'O', 'X', ' ', ' ', ' ', ' ', ' '])
		assert_equal(true, board.win?('X'))
	end

	def test_3_in_right_diagonal_row_winning_4x4_board_for_X_returns_true_for_X_win?
		board = Board.new(4, 3) 
		replace_initial_board_for_tests(board, ['X', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', ' '])
		assert_equal(true, board.win?('X'))
	end

	def test_2_non_sequential_in_row_returns_false_for_X_win?
		board = Board.new(3, 2) 
		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal(false, board.win?('X'))
	end

	def test_3_in_row_when_2_needed_returns_true_for_X_win?
		board = Board.new(3, 2) 
		replace_initial_board_for_tests(board, ['X', 'X', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal(true, board.win?('X'))
	end

	def test_winning_board_for_X_returns_false_for_O_win?
		board = Board.new(3, 3) 
		replace_initial_board_for_tests(board, ['X', 'X', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal(false, board.win?('O'))
	end

	def test_winning_board_for_O_returns_true_for_O_win?
		board = Board.new(4, 4) 
		replace_initial_board_for_tests(board, ['O', ' ', ' ', ' ', ' ', 'O', ' ', ' ', ' ', ' ', 'O', ' ', ' ', ' ', ' ', 'O'])
		assert_equal(true, board.win?('O'))
	end

	def test_winning_board_for_O_returns_true_for_O_win?
		board = Board.new(4, 3) 
		replace_initial_board_for_tests(board, [' ', ' ', ' ', ' ', ' ', 'O', ' ', ' ', ' ', ' ', 'O', ' ', ' ', ' ', ' ', 'O'])
		assert_equal(true, board.win?('O'))
	end

	def test_non_winning_board_for_O_returns_false_for_O_win?
		board = Board.new(4, 3) 
		replace_initial_board_for_tests(board, ['O', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', 'O', ' ', ' ', ' ', ' ', 'O'])
		assert_equal(false, board.win?('O'))
	end

	def test_marker_just_played_3x3_board
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal('X', board.marker_just_played)
	end

	def test_marker_just_played_4x4_board
		board = Board.new(4, 4)
		replace_initial_board_for_tests(board, ['O', 'O', ' ', ' ', ' ', 'X', 'O', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', 'X'])
		assert_equal('O', board.marker_just_played)
	end

	def test_marker_to_play_next_empty_3x3_board
		board = Board.new(3, 3)
		assert_equal('X', board.marker_to_play_next)
	end

	def test_marker_to_play_next_empty_4x4_board
		board = Board.new(4, 4)
		assert_equal('X', board.marker_to_play_next)
	end

	def test_marker_to_play_next_partial_board
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal('O', board.marker_to_play_next)
	end

	def test_next_sequential_space_available_empty_board
		board = Board.new(3, 3)
		assert_equal(0, board.available_spaces.first)
	end

	def test_next_sequential_space_available_empty_board_2
		board = Board.new(13, 13)
		assert_equal(0, board.available_spaces.first)
	end

	def test_next_sequential_space_available_partial_board
		board = Board.new(4, 4) 
		replace_initial_board_for_tests(board, ['O', 'O', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', 'X', ' ', ' ', ' ', ' ', 'X'])
		assert_equal(2, board.available_spaces.first)
	end

	def test_available_spaces
		board = Board.new(3, 3) 
		replace_initial_board_for_tests(board, ['X', 'O', 'X', 'O', 'X', 'O', 'X', ' ', ' '])
		assert_equal([7,8], board.available_spaces)
	end

	def test_available_spaces_2
		board = Board.new(2, 2) 
		replace_initial_board_for_tests(board, ['X', ' ', 'X', ' '])
		assert_equal([1,3], board.available_spaces)
	end

	def test_valid_space
		board = Board.new(3, 3) 
		replace_initial_board_for_tests(board, ['X', 'O', 'X', 'O', 'X', 'O', 'X', ' ', ' '])
		assert_equal(true, board.valid_space?(8))
		assert_equal(false, board.valid_space?(0))
		assert_equal(false, board.valid_space?(10))
	end
end
