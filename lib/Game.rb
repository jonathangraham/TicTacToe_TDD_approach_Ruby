
class Game

	attr_accessor :interface, :board, :player1, :player2, :current_player

	def initialize(interface, board_size, win_size, player1_info, player2_info)
		@interface = interface
		@board = Board.new(board_size, win_size)
		@player1 = player_setup(player1_info, 'X')
		@player2 = player_setup(player2_info, 'O')
	end

	def determine_current_player
		if board.marker_to_play_next == 'X'
			return player1
		else
			return player2
		end
	end

	def generate_move(current_player)
		current_player.determine_move(board)
	end

	def make_move(position)
		board.update_board(position, board.marker_to_play_next)
	end

	def game_over?
		board.game_end?
	end

	def valid_space?(position)
		board.valid_space?(position)
	end
	
	private

	def player_setup(players_info, marker)
        type = players_info[0]
        name = players_info[1]
        level = players_info[2]
        if type == 'ConsoleHuman'
          	ConsoleHuman.new(interface, name, marker)
      	elsif type == 'Human'
      		WebHuman.new(interface, name, marker)
        else
          if level == '1'
            SequentialAI.new("AI (level #{level})", marker)
          elsif level == '2'
            RandomAI.new("AI (level #{level})", marker)
          elsif level == '3'
            NegamaxAI.new("AI (level #{level})", marker)
          end
        end
    end
	
end
