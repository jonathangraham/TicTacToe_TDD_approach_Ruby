require_relative '../lib/ConsolePlay'

require 'minitest/autorun'

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

	# def test_play_game?
	# 	read_write = MockConsoleReadWrite.new
	# 	play = ConsolePlay.new(read_write)
	# 	array_lines_printed = play.play_game?
	# 	assert_equal(read_write.lines_printed[0], array_lines_printed[0])
	# 	#assert_equal(1, array_lines_printed.length)
	# end


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

# class TestConsolePlay < Minitest::Test

# 	def setup
# 		@console_human = ConsoleHuman.new(MockInterface.new, 'jon', 'X')
# 		@web_human = WebHuman.new('interface', 'jon', 'X')
# 		@board = 'board'
# 	end

# 	def test_console_human_implements_interface
# 		assert_respond_to(@console_human, :name)
# 		assert_respond_to(@console_human, :interface)
# 		assert_respond_to(@console_human, :marker)
# 	end

# 	def test_console_human_determine_move
# 		assert_equal('human response', @console_human.determine_move(@board))
# 	end

# 	def test_web_human_implements_interface
# 		assert_respond_to(@web_human, :position)
# 		assert_respond_to(@web_human, :name)
# 		assert_respond_to(@web_human, :interface)
# 		assert_respond_to(@web_human, :marker)
# 	end

# 	def test_web_human_determine_move_gives_default_position
# 		position = @web_human.position
# 		assert_equal(position, @web_human.determine_move(@board))
# 	end

# 	def test_web_human_determine_move_updated_position
# 		position = @web_human.position = rand(10)
# 		assert_equal(position, @web_human.determine_move(@board))
# 	end
	
# end

# class MockInterface

# 	def get_human_move()
# 		'human response'
# 	end
# end