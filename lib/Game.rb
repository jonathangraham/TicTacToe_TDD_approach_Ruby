class Game

	attr_accessor :board, :player1, :player2

	def initialize(board, player1, player2)
		@board = board
		@player1 = player1
		@player2 = player2
	end

	def generate_move(play_type)
		play_type.determine_move(board)
	end

	def make_move(board, position)
		board.update_board(position, board.marker_to_play_next)
	end
	
end
