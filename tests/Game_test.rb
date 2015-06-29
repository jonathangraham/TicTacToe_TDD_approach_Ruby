require_relative '../lib/Game'
require_relative '../lib/Board'
require_relative '../lib/Human'
require_relative '../lib/AI'

require 'minitest/autorun'

def replace_initial_board_for_tests(board, test_board)
	test_board.each_with_index do |e, i|
		board.update_board(i, e)
	end
end

class TestGame < Minitest::Test

	def test_initialization_of_new_game
		game = Game.new('interface', 3, 3, ['ConsoleHuman', 'jon', ""], ['Computer', "", "2"])
		board = Board.new(3,3)
		player1 = ConsoleHuman.new('interface', 'jon', 'X')
		player2 = RandomAI.new('AI (level 2)', 'O')
		assert_equal(board.board, game.board.board)
		assert_equal(player1.class, game.player1.class)
		assert_equal(player1.name, game.player1.name)
		assert_equal(player1.marker, game.player1.marker)
		assert_equal(player2.class, game.player2.class)
		assert_equal(player2.name, game.player2.name)
		assert_equal(player2.marker, game.player2.marker)
	end

	def test_determine_current_player_new_board
		game = Game.new('interface', 3, 3, ['ConsoleHuman', 'jon', ""], ['Computer', "", "2"])
		assert_equal(game.player1, game.determine_current_player)
	end

	def test_determine_current_player_partial_board
		game = Game.new('interface', 3, 3, ['ConsoleHuman', 'jon', ""], ['Computer', "", "2"])
		board = game.board
		replace_initial_board_for_tests(board, ['X', 'O', 'X', ' ', ' ', ' ', ' ', ' ', ' '])
		assert_equal(game.player2, game.determine_current_player)
	end

end