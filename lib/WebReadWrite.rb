require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'
require '/Users/jonathangraham/TTT_TDD/lib/WebReadWrite'
require 'sinatra'

class WebReadWrite < Sinatra::Base

  BOARD = nil
  GAME = nil
  PLAYER1 = nil
  PLAYER2 = nil
  BOARD_SIZE = nil
  WIN_SIZE = nil
  POSITION = nil
  CURRENT_PLAYER = nil


  get '/new_game' do
  	erb :new_game_form
  end

  post '/new_game' do
  	PLAYER1 = params[:player1]
    PLAYER2 = params[:player2]
    player1_name = params[:player1_name]
    player2_name = params[:player2_name]
    player1_level = params[:player1_level]
    player2_level = params[:player2_level]
    BOARD_SIZE = params[:board_size].to_i
    WIN_SIZE = params[:win_size].to_i
    if WIN_SIZE > BOARD_SIZE
      WIN_SIZE = BOARD_SIZE
    end    
    

    if PLAYER1 == 'Human'
    	PLAYER1 = Human.new(player1_name)
    elsif player1_level == 'Easy'
    	PLAYER1 = SequentialAI.new('Computer_Easy')
    elsif player1_level == 'Moderate'
    	PLAYER1 = RandomAI.new('Computer_Moderate')
    elsif player1_level == 'Hard'
    	PLAYER1 = NegamaxAI.new('Computer_Hard')
    end

	  if PLAYER2 == 'Human'
    	PLAYER2 = Human.new(player2_name)
    elsif player2_level == 'Easy'
    	PLAYER2 = SequentialAI.new('Computer_Easy')
    elsif player2_level == 'Moderate'
    	PLAYER2 = RandomAI.new('Computer_Moderate')
    elsif player2_level == 'Hard'
    	PLAYER2 = NegamaxAI.new('Computer_Hard')
    end

    
    BOARD = Board.new(BOARD_SIZE, WIN_SIZE)
    GAME = Game.new(BOARD, PLAYER1, PLAYER2)
  
    if PLAYER1.class != Human && PLAYER2.class != Human
      redirect '/computer_vs_computer'
    else
  	 redirect '/make_move'
    end
  end

  get '/make_move' do
    if BOARD.game_end?
      redirect '/game_over'
    end
    if CURRENT_PLAYER == PLAYER1
      CURRENT_PLAYER = PLAYER2
    else
      CURRENT_PLAYER = PLAYER1
    end
    if CURRENT_PLAYER.class != Human
      POSITION = CURRENT_PLAYER.determine_move(BOARD) 
      GAME.make_move(BOARD, POSITION)
      redirect '/make_move'
    else
      if BOARD.board.count(' ') == BOARD.board.length
        @message = "First go! #{CURRENT_PLAYER.name} to start."
      else
        @message = "Last play was in position #{POSITION}. #{CURRENT_PLAYER.name} take your turn."
      end
      erb :make_move_form, :locals => {'board' => BOARD.board,'board_index' => BOARD.index_board, 'player1' => PLAYER1, 'player2' => PLAYER2, 'board_size' => BOARD_SIZE, 'win_size' => WIN_SIZE}
    end  
  end

  post '/make_move' do
    POSITION = params[:move].to_i
    if BOARD.valid_space?(POSITION) == false
      redirect '/try_again'
    else
      GAME.make_move(BOARD, POSITION)
    end
    redirect '/make_move'
  end

  get '/try_again' do
    @message = "Position #{POSITION} is not valid. Choose an available space!"
    erb :make_move_form, :locals => {'board' => BOARD.board,'board_index' => BOARD.index_board, 'player1' => PLAYER1, 'player2' => PLAYER2, 'board_size' => BOARD_SIZE, 'win_size' => WIN_SIZE}
  end

  get '/game_over' do
    if BOARD.tie?
      @message = "Game was a tie. Would you like to play again?"
    else
      @message = "#{CURRENT_PLAYER.name} won! Would you like to play again?"
    end
    erb :game_over_form, :locals => {'board' => BOARD.board,'board_index' => BOARD.index_board, 'player1' => PLAYER1, 'player2' => PLAYER2, 'board_size' => BOARD_SIZE, 'win_size' => WIN_SIZE} 
  end

  post '/game_over' do
    if params[:play_again] == 'Yes'
      redirect '/new_game'
    else
      return "Goodbye!"
    end
  end

  get '/computer_vs_computer' do
    if BOARD.game_end?
      redirect '/game_over'
    end
    if CURRENT_PLAYER == PLAYER1
      CURRENT_PLAYER = PLAYER2
      @message = "#{PLAYER2.name} (O) to play next"
    else
      CURRENT_PLAYER = PLAYER1
      @message = "#{PLAYER1.name} (X) to play next"
    end
    erb :computer_vs_computer_form, :locals => {'board' => BOARD.board,'board_index' => BOARD.index_board, 'player1' => PLAYER1, 'player2' => PLAYER2, 'board_size' => BOARD_SIZE, 'win_size' => WIN_SIZE} 

  end

  post '/computer_vs_computer' do
    if params[:play] == 'Yes'
      POSITION = CURRENT_PLAYER.determine_move(BOARD) 
      GAME.make_move(BOARD, POSITION)
      redirect '/computer_vs_computer'
    else
      @message = "Game abandoned."
      erb :game_over_form, :locals => {'board' => BOARD.board,'board_index' => BOARD.index_board, 'player1' => PLAYER1, 'player2' => PLAYER2, 'board_size' => BOARD_SIZE, 'win_size' => WIN_SIZE} 
    end
  end


end
