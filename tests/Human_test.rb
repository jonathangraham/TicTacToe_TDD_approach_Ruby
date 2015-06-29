require '/Users/jonathangraham/TTT_TDD/lib/Human'

require 'minitest/autorun'

class TestHuman < Minitest::Test

	def setup
		@console_human = ConsoleHuman.new(MockInterface.new, 'jon', 'X')
		@web_human = WebHuman.new('interface', 'jon', 'X')
		@board = 'board'
	end

	def test_console_human_implements_interface
		assert_respond_to(@console_human, :name)
		assert_respond_to(@console_human, :interface)
		assert_respond_to(@console_human, :marker)
	end

	def test_console_human_determine_move
		assert_equal('human response', @console_human.determine_move(@board))
	end

	def test_web_human_implements_interface
		assert_respond_to(@web_human, :position)
		assert_respond_to(@web_human, :name)
		assert_respond_to(@web_human, :interface)
		assert_respond_to(@web_human, :marker)
	end

	def test_web_human_determine_move_gives_default_position
		position = @web_human.position
		assert_equal(position, @web_human.determine_move(@board))
	end

	def test_web_human_determine_move_updated_position
		position = @web_human.position = rand(10)
		assert_equal(position, @web_human.determine_move(@board))
	end
	
end

class MockInterface

	def get_human_move()
		'human response'
	end
end