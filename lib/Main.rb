require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'
require '/Users/jonathangraham/TTT_TDD/lib/UI'
require '/Users/jonathangraham/TTT_TDD/lib/ConsoleReadWrite'
require '/Users/jonathangraham/TTT_TDD/lib/WebReadWrite'

class Main 

	attr_reader :ui, :board, :player1, :player2, :game

	def initialize()
		@ui = ConsoleReadWrite.new
		@board = board_setup
		@player1 = player_setup(1)
		@player2 = player_setup(2)
		@game = Game.new(board, player1, player2)
	end 

	def board_setup()
		Board.new(get_board_size(), get_win_length())
	end

	def get_board_size()
		ui.ask_board_size
		board_size = ui.get_user_response.to_i
	end

	def get_win_length()
		ui.ask_how_many_in_row
		x_in_a_row = ui.get_user_response.to_i
	end

	def player_setup(number)
		ui.ask_player_type(number)
		player_type = ui.get_user_response
		if player_type == 'H'
			ui.ask_player_name
			name = ui.get_user_response
			Human.new(name)
		elsif player_type == 'C'
			RandomAI.new
		else
			player_setup(number)
		end
	end

	def play_game()
		players = [player1, player2].cycle
		until board.game_end? do
			current_player = players.next
			ui.display_current_status(board, current_player)
			position = get_move(current_player)
			game.make_move(board, position)
		end
		ui.display_end_result(board, current_player)
	end

	def get_move(current_player)
		if current_player.class.name == "Human"
			get_human_move
		else
			game.generate_move(current_player)
		end
	end

	def get_human_move()
		response = ui.get_user_response
		position = response.to_i
		until board.valid_space?(position)
			ui.print_valid_space_error
			response = ui.get_user_response
			position = response.to_i 
		end
		position
	end
end



play = Main.new
play.play_game


	# def game_cycle
	# 	ui.ask_play?
	# 	if ui.get_user_response == 'Y'
	# 		board = board_setup
	# 		player1 = player_setup(1)
	# 		player2 = player_setup(2)
	# 		play_new_game(board, player1, player2)
	# 	else
	# 		exit
	# 	end
	# 	game_cycle
	# end



