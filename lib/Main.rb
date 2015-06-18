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
			human_setup
		elsif player_type == 'C'
			computer_setup
		else
			player_setup(number)
		end
	end

	def human_setup()
		ui.ask_player_name
		name = ui.get_user_response
		Human.new(name)
	end

	def computer_setup()
		ui.ask_computer_level
		level = ui.get_user_response
		if level == '1'
			SequentialAI.new('Computer_easy')
		elsif level == '2'
			RandomAI.new('Computer_moderate')
		elsif level == '3'
			NegamaxAI.new('Computer_hard')
		else
			computer_setup
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
		play_again?
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

	def play_again?
		ui.ask_play?
		if ui.get_user_response.chomp.upcase == 'Y'
			Main.new.play_game 
		else
			exit
		end
	end		

end



play = Main.new
play.play_game




