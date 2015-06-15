class UI

	attr_reader :interface

	def initialize(interface)
		@interface = interface
	end

	def ask_play?()
		interface.print_line("Press Y to play new game.")
	end

	def ask_board_size()
		interface.print_line("Board size? (eg type '3' for a 3x3 board)")
	end

	def ask_how_many_in_row()
		interface.print_line("How many in a row needed to win? Can't be more than board size.")
	end

	def ask_player_type(number)
		interface.print_line("Player #{number}: Human(H) or Computer(C)?")
	end

	def ask_player_name
		interface.print_line("What is your name?")
	end

	def ask_computer_level
		interface.print_line("Easy(1), Moderate(2) or Hard(3)?")
	end

	def get_user_response
		interface.read_line
	end

	def print_board(board)
		lines = board.each_slice(Math.sqrt(board.length)).to_a
		lines.each do |line|
			interface.print_line("#{line.join('|')}")
		end
	end

	def print_player_turn(player)
		interface.print_line("#{player.name} to go next. Where do you want to play")
	end

	def print_valid_space_error()
		interface.print_line("Please enter a valid space")
	end

	def print_result(board, player)
		if board.win?(board.marker_just_played)
			interface.print_line("#{player.name} wins!")
		else
			interface.print_line("Game tied")
		end
	end

	def display_current_status(board, current_player)
		print_board(board.board)
		print_player_turn(current_player)
		print_board(board.index_board)
	end

	def display_end_result(board, current_player)
		print_board(board.board)
		print_result(board, current_player)
	end
end
