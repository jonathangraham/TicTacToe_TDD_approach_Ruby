require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'
require '/Users/jonathangraham/TTT_TDD/lib/WebReadWrite'
require 'sinatra'

class WebReadWrite < Sinatra::Base

	# attr_reader :board, :player1, :player2, :game

	# def initialize()
	# 	@board = board
	# 	@player1 = player1
	# 	@player2 = player2
	# 	@game = game
	# end 	

  # BOARD = nil
  # GAME = nil

  get '/' do
    "Welcome to TicTacToe!"
  end

  get '/new_game' do
  	erb :new_game_form
  end

  post '/new_game' do
  	player1 = params[:player1]
    player2 = params[:player2]
    player1_name = params[:player1_name]
    player2_name = params[:player2_name]
    player1_level = params[:player1_level]
    player2_level = params[:player2_level]
    board_size = params[:board_size].to_i
    win_size = params[:win_size].to_i

    # players = [player1, player2]
 
    # players = players.map do |player|
    # 	if player == 'Human'
    # 	Human.new('test_player1')
    # 	else 
    # 	RandomAI.new
    # 	end	
    # end

    # player1 = players[0]
    # player2 = players[1]

    if player1 == 'Human'
    	player1 = Human.new(player1_name)
    elsif player1_level == 'Easy'
    	player1 = SequentialAI.new
    elsif player1_level == 'Moderate'
    	player1 = RandomAI.new
    elsif player1_level == 'Hard'
    	player1 = NegamaxAI.new
    end

	if player2 == 'Human'
    	player2 = Human.new(player2_name)
    elsif player2_level == 'Easy'
    	player2 = SequentialAI.new
    elsif player2_level == 'Moderate'
    	player2 = RandomAI.new
    elsif player2_level == 'Hard'
    	player2 = NegamaxAI.new
    end

    
    board = Board.new(board_size, win_size)
    game = Game.new(board, player1, player2)

		# players = [player1, player2].cycle
		# until board.game_end? do
		# 	current_player = players.next
		# 	#ui.display_current_status(board, current_player)
		# 	position = game.generate_move(current_player)
		# 	game.make_move(board, position)
		# end

  	    erb :index, :locals => {'board' => board.index_board, 'player1' => player1, 'player2' => player2, 'board_size' => board_size, 'win_size' => win_size}

  	    # redirect '/new_game'
  end

end
