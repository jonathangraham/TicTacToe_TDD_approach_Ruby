require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'
require '/Users/jonathangraham/TTT_TDD/lib/UI'
require '/Users/jonathangraham/TTT_TDD/lib/ConsoleReadWrite'

require 'minitest/autorun'

def replace_initial_board_for_tests(board, test_board)
	test_board.each_with_index do |e, i|
		board.update_board(i, e)
	end
end

class MockConsoleReadWrite
	attr_accessor :lines_printed
	attr_accessor :lines_to_read

	def initialize
		@lines_printed =[]
		@lines_to_read = []
	end

	def print_line(str)
		@lines_printed << str
	end

	def read_line
		str = "read_line called"
		@lines_to_read << str
	end
end


class TestUI < Minitest::Test

	def test_ask_play?
		mock_console_read_write = MockConsoleReadWrite.new
		play = UI.new(mock_console_read_write)
		array_lines_printed = play.ask_play?
		assert_equal(mock_console_read_write.lines_printed[0], array_lines_printed[0])
		assert_equal(1, array_lines_printed.length)
	end

	def test_get_response
		mock_console_read_write = MockConsoleReadWrite.new
		play = UI.new(mock_console_read_write)
		array_lines_read = play.get_user_response
		assert_equal(mock_console_read_write.lines_to_read[0], array_lines_read[0])		
	end

	def test_print_initial_3x3_board
		mock_console_read_write = MockConsoleReadWrite.new
		board = Board.new(3, 3)
		play = UI.new(mock_console_read_write)
		assert_equal(3, play.print_board(board.board).length)
	end

	def test_print_4x4_board_with_index_positions
		mock_console_read_write = MockConsoleReadWrite.new
		board = Board.new(4, 4)
		play = UI.new(mock_console_read_write)
		assert_equal(4, play.print_board(board.index_board).length)
	end

	def test_print_player_to_go_next
		mock_console_read_write = MockConsoleReadWrite.new		
		play = UI.new(mock_console_read_write)
		assert_equal(mock_console_read_write.lines_printed, play.print_player_turn(NegamaxAI))
	end

end
