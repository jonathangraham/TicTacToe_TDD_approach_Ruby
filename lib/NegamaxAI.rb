class NegamaxAI

	attr_reader :name, :type

	def initialize(name)
		@name = name
		@type = 'Computer'
	end

	def determine_move(board)
		player = board.marker_to_play_next
		depth = 1
		negamax(board, player, depth)
		return @negamax_move
	end

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
	         				@negamax_move = space
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
