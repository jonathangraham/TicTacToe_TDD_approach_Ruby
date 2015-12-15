require_relative 'Game'
require_relative 'Board'
require_relative 'AI'
require_relative 'Human'
require 'sinatra'

class WebAppStart < Sinatra::Base


  #use database redis to store session data, and then rebuild object when id called

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

    game = Game.new(WebAppStart, board_size, win_size, player1_info, player2_info)

    session[:game] = game
    session[:board] = game.board
    session[:player1] = game.player1
    session[:player2] = game.player2
    session[:current_player] = game.determine_current_player
    session[:locals] = {
      'board' => session[:board].board,
      'board_index' => session[:board].index_board, 
      'player1' => session[:player1], 
      'player2' => session[:player2], 
      'board_size' => session[:board].grid_size, 
      'win_size' => session[:board].x_in_a_row
    }

    redirect '/CurrentStatus'
  end

  get '/CurrentStatus' do
    @message = "Lets play! #{session[:current_player].name} (#{session[:current_player].marker}) to start"
    erb :status_form, :locals => session[:locals]
  end

  post '/CurrentStatus' do
    displayed = params[:play]
    if displayed == 'Yes'
      redirect '/get_move'
    else
      "Goodbye"
    end
  end

  get '/get_move' do
    player = session[:current_player]
    #board = session[:board]
    game = session[:game]
    session[:position] = game.generate_move(player)
    redirect '/check_move'
    # if game.valid_space?(session[:position])
    #   redirect '/make_move'  
    # else
    #   @message = "#{player.name}: choose an available space to make your move!"
    #   erb :human_form, :locals => session[:locals]
    # end
  end

  get '/check_move' do
    game = session[:game]
    player = session[:current_player]
    if session[:position] && game.valid_space?(session[:position])
      redirect '/make_move'  
    else
      @message = "#{player.name}: choose an available space to make your move!"
      erb :human_form, :locals => session[:locals]
    end
  end


  post '/get_move' do
    space = params[:move].to_i
    session[:current_player].position = space
    redirect '/get_move'
  end

  get '/make_move' do
    game = session[:game]
    position = session[:position]
    game.make_move(position)
    if game.game_over?
      redirect '/game_over'
    else
      player = session[:current_player]
      session[:current_player] = game.determine_current_player
      next_player = session[:current_player]
      @message = "#{player.name} just played in position #{position}. #{next_player.name}, are you ready to play?"
      erb :status_form, :locals => session[:locals]
    end
  end

  get '/game_over' do
    player = session[:current_player]
    if session[:board].win?(player.marker)
      @message = "#{player.name} won! Would you like to play again?"
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

end  
