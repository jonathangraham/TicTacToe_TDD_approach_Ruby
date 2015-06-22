require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'
#require '/Users/jonathangraham/TTT_TDD/lib/WebReadWrite'
require 'sinatra'


#class WebReadWrite < Sinatra::Base

  enable :sessions

  get '/' do
    redirect '/new_game'
  end
  
  get '/new_game' do
    erb :new_game_form
  end

  post '/new_game' do
    player1_info = [params[:player1], params[:player1_name], params[:player1_level]]
    player2_info = [params[:player2], params[:player2_name], params[:player2_level]]
    players_info = [player1_info, player2_info]
    board_size = [params[:board_size].to_i, 2].max
    win_size = [params[:win_size].to_i, 2].max
    if win_size > board_size
      win_size = board_size
    end

    session[:board] = new_board(board_size, win_size)
    session[:player1] = player_setup(players_info, 0)
    session[:player2] = player_setup(players_info, 1)
    session[:current_player] = nil
    session[:game] = game_setup(session[:board], session[:player1], session[:player2])
    session[:locals] = {
      'board' => session[:board].board,
      'board_index' => session[:board].index_board, 
      'player1' => session[:player1], 
      'player2' => session[:player2], 
      'board_size' => session[:board].rows.length, 
      'win_size' => session[:board].x_in_a_row
    }

    redirect '/start_game'
  end

  get '/start_game' do
    if session[:player1].class != Human && session[:player2].class != Human
      redirect '/computer_vs_computer'
    else
     redirect '/make_move'
    end
  end

  get '/make_move' do
    redirect '/game_over' if session[:board].game_end?   
    change_player
    if session[:current_player].class != Human
      session[:position] = session[:current_player].determine_move(session[:board]) 
      session[:game].make_move(session[:board], session[:position])
      redirect '/make_move'
    else
      if session[:board].board.count(' ') == session[:board].board.length
        @message = "First go! #{session[:current_player].name} to start."
      else
        @message = "Last play was in position #{session[:position]}. #{session[:current_player].name} take your turn."
      end
      erb :make_move_form, :locals => session[:locals]
    end  
  end

  post '/make_move' do
    session[:position] = params[:move].to_i
    if session[:board].valid_space?(session[:position]) == false
      redirect '/try_again/'
    else
      session[:game].make_move(session[:board], session[:position])
    end
    redirect '/make_move'
  end

  get '/try_again/' do
    @message = "Position #{session[:position]} is not valid. Choose an available space!"
    erb :make_move_form, :locals => session[:locals]
  end

  get '/game_over' do
    if session[:board].tie?
      @message = "Game was a tie. Would you like to play again?"
    else
      @message = "#{session[:current_player].name} won! Would you like to play again?"
    end
    erb :game_over_form, :locals => session[:locals]
  end

  post '/game_over' do
    if params[:play_again] == 'Yes'
      redirect '/new_game'
    else
      return "Goodbye!"
    end
  end

  get '/computer_vs_computer' do   
    redirect '/game_over' if session[:board].game_end?
    change_player
    @message = "#{session[:current_player].name} to play next"
    erb :computer_vs_computer_form, :locals => session[:locals]

  end

  post '/computer_vs_computer' do
    if params[:play] == 'Yes'
      session[:position] = session[:current_player].determine_move(session[:board]) 
      session[:game].make_move(session[:board], session[:position])
      redirect '/computer_vs_computer'
    else
      @message = "Game abandoned."
      erb :game_over_form, :locals => LOCALS
    end
  end

  helpers do

    def new_board(board_size, win_size)
      Board.new(board_size, win_size)
    end

    def player_setup(players_info, number)
      players = players_info.map do |player|
        if player[0] == 'Human'
          Human.new(player[1])
        elsif player[2] == 'Easy'
          SequentialAI.new('Computer_Easy')
        elsif player[2] == 'Moderate'
          RandomAI.new('Computer_Moderate')
        elsif player[2] == 'Hard'
          NegamaxAI.new('Computer_Hard')
        end
      end
      players[number]
    end

    def game_setup(board, player1, player2)
      Game.new(board, player1, player2)
    end

    def change_player
      if session[:current_player] == session[:player1] 
        session[:current_player] = session[:player2] 
      else
        session[:current_player] = session[:player1]
      end
    end

  end

#end


