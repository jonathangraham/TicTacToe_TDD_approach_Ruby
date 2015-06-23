require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'
require 'sinatra'


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
    board_size = [params[:board_size].to_i, 3].max
    win_size = [params[:win_size].to_i, 3].max
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

    redirect "/next_move"
  end

  get '/next_move' do
    redirect '/game_over' if game_over?   
    change_player
    redirect "/#{session[:current_player].type}"
  end

  get '/Human' do
    @message = next_move_message
    erb :human_form, :locals => session[:locals]
  end

  post '/Human' do
    session[:position] = params[:move].to_i 
    redirect '/try_again/' if not_valid_space? 
    redirect '/play_move'
  end

  get '/try_again/' do
    @message = "Position #{session[:position]} is not valid. Choose an available space!"
    erb :human_form, :locals => session[:locals]
  end

  get '/play_move' do
    session[:game].make_move(session[:board], session[:position])
    redirect 'next_move'
  end

  get '/game_over' do
    if win?
      @message = "#{session[:current_player].name} won! Would you like to play again?"
    else
      @message = "Game was a tie. Would you like to play again?"
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

  get '/Computer' do   
    @message = next_move_message
    erb :computer_form, :locals => session[:locals]
  end

  post '/Computer' do
    if params[:play] == 'Yes'
      session[:position] = session[:current_player].determine_move(session[:board])
      redirect '/play_move'
    else
      @message = "Game abandoned."
      erb :game_over_form, :locals => session[:locals]
    end
  end

  helpers do

    def new_board(board_size, win_size)
      Board.new(board_size, win_size)
    end

    def player_setup(players_info, number)
      players = players_info.map do |player|
        type = player[0]
        name = player[1]
        level = player[2]
        if type == 'Human'
          Human.new(name)
        else
          if level == 'Easy'
            SequentialAI.new("AI(#{level})")
          elsif level == 'Moderate'
            RandomAI.new("AI(#{level})")
          elsif level == 'Hard'
            NegamaxAI.new("AI(#{level})")
          end
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

    def game_over?
      session[:board].game_end? 
    end

    def next_move_message
      if new_board? 
        "First go! #{session[:current_player].name} to start."
      else
        "Last play was in position #{session[:position]}. #{session[:current_player].name} take your turn."
      end
    end

    def new_board?
      session[:board].board.count(' ') == session[:board].board.length
    end

    def not_valid_space?
      session[:board].valid_space?(session[:position]) == false
    end

    def win?
      marker_played = session[:board].marker_just_played
      session[:board].win?(marker_played)
    end

  end
