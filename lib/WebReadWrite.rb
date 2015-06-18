require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'
require '/Users/jonathangraham/TTT_TDD/lib/WebReadWrite'
require 'sinatra'

class WebPlay

  attr_accessor :player1, :player2, :board, :game, :current_player

  def initialize(players_info, board_size, win_size)
    @player1 = player_setup(players_info, 0)
    @player2 = player_setup(players_info, 1)
    @board = Board.new(board_size, win_size)
    @game = game_setup
    @current_player = nil
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

  def game_setup
    Game.new(board, player1, player2)
  end

  def change_player
    if current_player == player1 
      @current_player = player2 
    else
      @current_player = player1
    end
  end

end

class WebReadWrite < Sinatra::Base

  WEB_PLAY = nil
  POSITION = nil
  LOCALS = nil

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

    WEB_PLAY = WebPlay.new(players_info, board_size, win_size)
    LOCALS = {
      'board' => WEB_PLAY.board.board,
      'board_index' => WEB_PLAY.board.index_board, 
      'player1' => WEB_PLAY.player1, 
      'player2' => WEB_PLAY.player2, 
      'board_size' => WEB_PLAY.board.rows.length, 
      'win_size' => WEB_PLAY.board.x_in_a_row
    }


    redirect '/start_game'
  end

  get '/start_game' do
    if WEB_PLAY.player1.class != Human && WEB_PLAY.player2.class != Human
      redirect '/computer_vs_computer'
    else
  	 redirect '/make_move'
    end
  end

  get '/make_move' do
    redirect '/game_over' if WEB_PLAY.board.game_end?   
    current_player = WEB_PLAY.change_player
    if current_player.class != Human
      POSITION = current_player.determine_move(WEB_PLAY.board) 
      WEB_PLAY.game.make_move(WEB_PLAY.board, POSITION)
      redirect '/make_move'
    else
      if WEB_PLAY.board.board.count(' ') == WEB_PLAY.board.board.length
        @message = "First go! #{current_player.name} to start."
      else
        @message = "Last play was in position #{POSITION}. #{current_player.name} take your turn."
      end
      erb :make_move_form, :locals => LOCALS
    end  
  end

  post '/make_move' do
    POSITION = params[:move].to_i
    if WEB_PLAY.board.valid_space?(POSITION) == false
      redirect '/try_again/'
    else
      WEB_PLAY.game.make_move(WEB_PLAY.board, POSITION)
    end
    redirect '/make_move'
  end

  get '/try_again' do
    @message = "Position #{POSITION} is not valid. Choose an available space!"
    erb :make_move_form, :locals => LOCALS
  end

  get '/game_over' do
    if WEB_PLAY.board.tie?
      @message = "Game was a tie. Would you like to play again?"
    else
      @message = "#{WEB_PLAY.current_player.name} won! Would you like to play again?"
    end
    erb :game_over_form, :locals => LOCALS
  end

  post '/game_over' do
    if params[:play_again] == 'Yes'
      redirect '/new_game'
    else
      return "Goodbye!"
    end
  end

  get '/computer_vs_computer' do   
    redirect '/game_over' if WEB_PLAY.board.game_end?
    current_player = WEB_PLAY.change_player
    @message = "#{current_player.name} to play next"
    erb :computer_vs_computer_form, :locals => LOCALS

  end

  post '/computer_vs_computer' do
    if params[:play] == 'Yes'
      POSITION = WEB_PLAY.current_player.determine_move(WEB_PLAY.board) 
      WEB_PLAY.game.make_move(WEB_PLAY.board, POSITION)
      redirect '/computer_vs_computer'
    else
      @message = "Game abandoned."
      erb :game_over_form, :locals => LOCALS
    end
  end

end
