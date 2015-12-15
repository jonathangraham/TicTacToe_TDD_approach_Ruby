require_relative 'Game'
require_relative 'Board'
require_relative 'AI'
require_relative 'Human'

class ConsoleStart

	attr_reader :ui, :game, :board, :player1, :player2, :current_player

	def initialize(ui)
		@ui = ui
		@game = nil
		@board = nil
		@player1 = nil
		@player2 = nil
		@current_player = nil
	end 

	def play_game?
		start_game if play?
	end	

	def start_game
		get_game_parameters
		play_game
	end


	def play_game
		@current_player = game.determine_current_player
		display_current_status
		position = game.generate_move(current_player)
		game.make_move(position)
		if game.game_over?
			display_end_result
		else
			play_game
		end
	end

	def get_human_move()
		position = ui.get_user_response.to_i
		until game.valid_space?(position)
			position = get_valid_space
		end
		position
	end


	private

	def get_game_parameters
		board_size = get_board_size
		win_size = get_win_length
		player1_info = player_setup(1)
		player2_info = player_setup(2)
		create_game(board_size, win_size, player1_info, player2_info)
	end

	def create_game(board_size, win_size, player1_info, player2_info)
		@game = Game.new(self, board_size, win_size, player1_info, player2_info)
		@board = game.board
		@player1 = game.player1
		@player2 = game.player2
	end

	def get_board_size()
		ask_board_size
		return ui.get_user_response.to_i
	end

	def get_win_length()
		ask_how_many_in_row
		return ui.get_user_response.to_i
	end

	def player_setup(number)
		type = player_type(number)
		name = player_name(type) || ""
		level = player_level(type) || ""
		return [type, name, level]
	end

	def player_type(number)
		ask_player_type(number)
		player_type = ui.get_user_response
		if player_type == 'H'
			return 'ConsoleHuman'
		elsif player_type == 'C'
			return 'Computer'
		else
			player_setup(number)
		end
	end

	def player_level(type)
		if type == 'Computer'
			ask_computer_level
			level = ui.get_user_response
			if ['1', '2', '3'].include?(level)
				return level
			else
				player_level(type, number)
			end
		end
	end

	def player_name(type)
		if type == 'ConsoleHuman'
			ask_player_name
			return ui.get_user_response
		end
	end

	def play?()
		ui.print_line("Press Y to play new game.")
		ui.get_user_response.chomp.upcase == 'Y'
	end

	def ask_board_size()
		ui.print_line("Board size? (eg type '3' for a 3x3 board)")
	end

	def ask_how_many_in_row()
		ui.print_line("How many in a row needed to win? Can't be more than board size.")
	end

	def ask_player_type(number)
		ui.print_line("Player #{number}: Human(H) or Computer(C)?")
	end

	def ask_player_name
		ui.print_line("What is your name?")
	end

	def ask_computer_level
		ui.print_line("Easy(1), Moderate(2) or Hard(3)?")
	end

	def display_current_status()
		print_board(board.board)
		print_player_turn(current_player)
		print_board(board.index_board)
	end	

	def display_end_result()
		print_board(board.board)
		print_result(board, current_player)
		play_game?
	end

	def print_board(board)
		lines = board.each_slice(Math.sqrt(board.length)).to_a
		lines.each do |line|
			ui.print_line("#{line.join('|')}")
		end
	end

	def print_player_turn(player)
		ui.print_line("#{player.name} to go next. Where do you want to play")
	end

	def get_valid_space
		ui.print_line("Please enter a valid space")
		ui.get_user_response.to_i
	end

	def print_result(board, player)
		if board.win?(player.marker)
			ui.print_line("#{player.name} wins!")
		else
			ui.print_line("Game tied")
		end
	end

end

class ConsoleReadWrite

	def print_line(str)
		puts str
	end

	def read_line
		gets.chomp.upcase
	end

	def get_user_response
		read_line
	end

end

read_write = ConsoleReadWrite.new
console = ConsoleStart.new(read_write)
console.play_game?
