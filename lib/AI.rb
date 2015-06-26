class AI

	attr_reader :name, :marker

	def initialize(name, marker)
		@name = name
		@marker = marker
	end

end

class SequentialAI < AI

	def determine_move(board)
		@position = board.available_spaces.first
	end
end

class RandomAI < AI

	def determine_move(board)
		@position = board.available_spaces.sample
	end
end

class NegamaxAI < AI

	def determine_move(board)
		depth = 1
		negamax(board, marker, depth)
		return @position
	end

	private

		def negamax(board, current_marker, depth)
			opponent_marker = opponent(current_marker)
	    	if board.game_end?
	      		return score(board, current_marker, opponent_marker, depth)
	    	else
	      		best_rank = -999
	      		board.available_spaces.each do |space|
	        		board.update_board(space, current_marker)
	        		rank = -negamax(board, opponent_marker, depth + 1 )
	       			board.update_board(space, ' ')
		       			if rank > best_rank
		         			best_rank = rank
		         			if depth == 1
		         				@position = space
		         			end
						end
	     		end
	     		return best_rank
			end
		end

		def score(board, current_marker, opponent_marker, depth)
			if board.win?(current_marker)
				return 100 - depth
			elsif board.win?(opponent_marker)
			    return -(100 - depth)
			else
			    return 0
			end
		end

		def opponent(marker)
			marker == "X" ? "O" : "X"
		end
end
