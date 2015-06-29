require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/AI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'

require 'minitest/autorun'

# def replace_initial_board_for_tests(board, test_board)
# 	test_board.each_with_index do |e, i|
# 		board.update_board(i, e)
# 	end
# end

class TestGame < Minitest::Test

	def test_initialization_of_new_game
		game = Game.new('interface', 3, 3, ['ConsoleHuman', 'jon', ""], ['Computer', "", "2"])
		assert_equal([" ", " ", " ", " ", " ", " ", " ", " ", " "], game.board.board)
		assert_equal(ConsoleHuman, game.player1.class)
		assert_equal('jon', game.player1.name)
		assert_equal('X', game.player1.marker)
		assert_equal(RandomAI, game.player2.class)
		assert_equal('AI (level 2)', game.player2.name)
		assert_equal('O', game.player2.marker)
	end

end
	
# 	def test_sequential_game_move_determination
# 		board = Board.new(3, 3)
# 		player1 = SequentialAI.new('Comp')
# 		player2 = SequentialAI.new('Comp')
# 		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
# 		mock_console_read_write = MockConsoleReadWrite.new
# 		ui = UI.new(mock_console_read_write)
# 		game = Game.new(board, player1, player2)
# 		assert_equal(3, game.generate_move(player2))
# 	end

# 	def test_random_game_move_determination
# 		board = Board.new(3, 3)
# 		player1 = RandomAI.new('Comp')
# 		player2 = RandomAI.new('Comp')
# 		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', ' ', 'O', 'X', 'O', 'X'])
# 		mock_console_read_write = MockConsoleReadWrite.new
# 		ui = UI.new(mock_console_read_write)
# 		game = Game.new(board, player1, player2)
# 		assert_equal(true, [3,4].include?(game.generate_move(player2)))
# 	end

# 	def test_negamax_game_move_determination
# 		board = Board.new(3, 3)
# 		player1 = RandomAI.new('Comp')
# 		player2 = NegamaxAI.new('Comp')
# 		replace_initial_board_for_tests(board, [' ', ' ', 'X', ' ', 'O', ' ', 'X', ' ', ' '])
# 		mock_console_read_write = MockConsoleReadWrite.new
# 		ui = UI.new(mock_console_read_write)
# 		game = Game.new(board, player1, player2)
# 		assert_equal(1, game.generate_move(player2))
# 	end

# 	def test_make_move
# 		board = Board.new(3, 3)
# 		player1 = SequentialAI.new('Comp')
# 		player2 = SequentialAI.new('Comp')
# 		replace_initial_board_for_tests(board, ['X', 'O', 'X', 'O', ' ', ' ', ' ', ' ', ' '])
# 		mock_console_read_write = MockConsoleReadWrite.new
# 		ui = UI.new(mock_console_read_write)
# 		game = Game.new(board, player1, player2)
# 		position = game.generate_move(player1)
# 		game.make_move(board, position)
# 		assert_equal(['X', 'O', 'X', 'O', 'X', ' ', ' ', ' ', ' '], board.board)
# 	end	

# end


# class MockConsoleReadWrite
# 	attr_accessor :lines_printed
# 	attr_accessor :lines_to_read

# 	def initialize
# 		@lines_printed =[]
# 		@lines_to_read = []
# 	end

# 	def print_line(str)
# 		@lines_printed << str
# 	end

# 	def read_line
# 		str = "read_line called"
# 		@lines_to_read << str
# 	end
# end
