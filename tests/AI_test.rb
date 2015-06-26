require '/Users/jonathangraham/TTT_TDD/lib/AI'
require '/Users/jonathangraham/TTT_TDD/lib/Board'
require 'minitest/autorun'

def replace_initial_board_for_tests(board, test_board)
	test_board.each_with_index do |e, i|
		board.update_board(i, e)
	end
end

class TestAI < Minitest::Test
	def test_generate_position_with_sequential_rules
		board = Board.new(3, 3) 
		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		ai = SequentialAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(3, position)
	end

	def test_generate_position_with_randomAI_single_option
		board = Board.new(3, 3) 
		replace_initial_board_for_tests(board, ['X', 'O', 'X', 'O', ' ', 'O', 'X', 'X', 'O'])
		ai = RandomAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(4, position)
	end

	def test_generate_position_with_randomAI_multiple_options
		board = Board.new(2, 2)
		replace_initial_board_for_tests(board, ['X', ' ', ' ', 'O'])
		ai = RandomAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(true, [1,2].include?(position))
	end

	def test_generate_position_with_negamaxAI_single_option
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', 'O', 'X', 'O', ' ', 'O', 'X', 'X', 'O'])
		ai = NegamaxAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(4, position)
	end

	def test_generate_position_with_negamexAI_move_to_win_1
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', ' ', 'O', 'X', 'O', 'X', ' ', ' ', 'O'])
		ai = NegamaxAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(6, position)
	end

	def test_generate_position_with_negamexAI_move_to_win_2
		board = Board.new(4, 4)
		replace_initial_board_for_tests(board, ['X', 'X', 'X', ' ', 'O', 'X', 'O', 'X', ' ', ' ', ' ', ' ', 'O', 'O', ' ', 'O'])
		ai = NegamaxAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(3, position)
	end

	def test_generate_position_with_negamexAI_move_to_win_3
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, [' ', 'X', ' ', 'X', 'O', 'X', ' ', ' ', 'O'])
		ai = NegamaxAI.new('Comp', 'O')
		position = ai.determine_move(board)
		assert_equal(0, position)
	end

	def test_generate_position_with_negamexAI_block_opponent_win
		board = Board.new(4, 4)
		replace_initial_board_for_tests(board, ['X', 'X', 'X', ' ', 'O', 'X', 'O', 'X', ' ', ' ', ' ', ' ', 'O', 'O', 'X', 'O'])
		ai = NegamaxAI.new('Comp', 'O')
		position = ai.determine_move(board)
		assert_equal(3, position)
	end

	def test_generate_position_with_negamexAI_block_opponent_win_1
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', 'O', ' ', ' ', ' ', ' '])
		ai = NegamaxAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(7, position)
	end

	def test_generate_position_with_negamexAI_block_opponent_win_2
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', 'O', ' ', 'O', 'X', 'X', ' ', ' ', ' '])
		ai = NegamaxAI.new('Comp', 'O')
		position = ai.determine_move(board)
		assert_equal(8, position)
	end

	def test_generate_position_with_negamexAI_win_instead_block_1
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['X', ' ', 'O', 'X', ' ', 'O', ' ', ' ', ' '])
		ai = NegamaxAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(6, position)
	end

	def test_generate_position_with_negamexAI_create_fork
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, ['O', ' ', ' ', ' ', ' ', ' ', 'X', 'O', 'X'])
		ai = NegamaxAI.new('Comp', 'X')
		position = ai.determine_move(board)
		assert_equal(2, position)
	end

	def test_generate_position_with_negamexAI_block_fork
		board = Board.new(3, 3)
		replace_initial_board_for_tests(board, [' ', ' ', 'X', ' ', 'O', ' ', 'X', ' ', ' '])
		ai = NegamaxAI.new('Comp', 'O')
		position = ai.determine_move(board)
		assert_equal(1, position)
	end
end
