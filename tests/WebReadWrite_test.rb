ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../lib/WebPlay'
require_relative '../lib/Game'
require_relative '../lib/Board'


class CurrentUserSession < Minitest::Test
  include Rack::Test::Methods
 
  def app
    WebAppStart
  end

  def new_setup
    post'/new_game', {"player1" => "Human", "player1_name" => "test_name", "player1_level" => "", 
      "player2" => "Computer", "player2_name" => "", "player2_level" => "1",
      "board_size" => "3", "win_size" => "3"}
  end

  def new_setup2
    post'/new_game', {"player2" => "Human", "player2_name" => "test_name", "player2_level" => "", 
      "player1" => "Computer", "player1_name" => "", "player1_level" => "1",
      "board_size" => "3", "win_size" => "3"}
  end

  # def mock_setup
  #   player1_info = ["Human", "test_name", ""]
  #   player2_info = ["Computer", "", "1"]
  #   players_info = [player1_info, player2_info]
  #   board_size = 3
  #   win_size = 3
  #   # if win_size > board_size
  #   #   win_size = board_size
  #   # end

  #   game = MockGame.new(WebAppStart, board_size, win_size, player1_info, player2_info)

  #   # session[:game] = game
  #   board = game.board
  #   player1 = game.player1
  #   player2 = game.player2
  #   current_player = game.determine_current_player
  #   locals = {
  #     'board' => board.board,
  #     'board_index' => board.index_board, 
  #     'player1' => player1, 
  #     'player2' => player2, 
  #     'board_size' => board.grid_size, 
  #     'win_size' => board.x_in_a_row
  #   }
  # end

  def test_it_redirects_to_new_game_with_root_url 
    get '/'
    follow_redirect!
    assert_equal "http://example.org/new_game", last_request.url
  end

  def test_new_game_opens_new_game_form
    get '/new_game' 
    assert last_response.ok?
    assert last_response.body.include?('form action="/new_game" method="POST"')
    assert last_response.body.include?('If Human, type your name: <input type="text" name="player2_name">')
  end

  def test_post_new_game_creates_new_game
    new_setup
    game = Game.new(WebAppStart, 3, 3, ['Human', 'test_name', ""], ['Computer', "", "1"])
    assert_equal(Board.new(3,3).board, last_request.session[:game].board.board)
    assert_equal(game.board.board, last_request.session[:game].board.board)
    assert_equal(game.player1.name, last_request.session[:game].player1.name)
    assert_equal(game.player2.class, last_request.session[:game].player2.class)
  end

  def test_post_new_game_redirects_to_CurrentStatus
    new_setup 
    follow_redirect!
    assert_equal "http://example.org/CurrentStatus", last_request.url
  end

  def test_CurrentStatus_opens_new_game_form
    new_setup
    get '/CurrentStatus' 
    assert last_response.ok?
    assert last_response.body.include?('<form action="/CurrentStatus" method="POST">')
  end

  def test_CurrentStatus_redirects_to_get_move_if_yes
    new_setup
    post '/CurrentStatus', {"play" => "Yes"}
    follow_redirect!
    assert_equal "http://example.org/get_move", last_request.url
  end

  def test_CurrentStatus_displays_Goodbye_if_no
    new_setup
    post '/CurrentStatus', {"play" => "No"}
    assert_equal 'Goodbye', last_response.body
  end

  def test_get_move
    new_setup
    get '/get_move'
    follow_redirect!
    assert_equal "http://example.org/check_move", last_request.url
  end

  def test_check_move_opens_human_form_for_human_move
    new_setup
    get '/check_move'

    assert last_response.ok?
    assert last_response.body.include?('<form action="/get_move" method="POST">')
  end

  # def test_check_move_redirects_make_move_for_computer_move
  #   new_setup2
  #   get '/check_move'
  #   follow_redirect!
  #   assert_equal "http://example.org/check_move", last_request.url
  # end



end

class MockGame

  
  attr_accessor :interface, :board, :player1, :player2, :current_player

  def initialize(interface, board_size, win_size, player1_info, player2_info)
    @interface = interface
    @board = Board.new(board_size, win_size)
    @player1 = player_setup(player1_info, 'X')
    @player2 = player_setup(player2_info, 'O')
  end

  def determine_current_player
    if board.marker_to_play_next == 'X'
      return player1
    else
      return player2
    end
  end

  def generate_move(current_player)
    # current_player.determine_move(board)
    5
  end

  def make_move(position)
    board.update_board(position, board.marker_to_play_next)
  end

  def game_over?
    board.game_end?
  end

  def valid_space?(position)
    # board.valid_space?(position)
    true
  end
  
  private

  def player_setup(players_info, marker)
        type = players_info[0]
        name = players_info[1]
        level = players_info[2]
        if type == 'ConsoleHuman'
            ConsoleHuman.new(interface, name, marker)
        elsif type == 'Human'
          WebHuman.new(interface, name, marker)
        else
          if level == '1'
            SequentialAI.new("AI (level #{level})", marker)
          elsif level == '2'
            RandomAI.new("AI (level #{level})", marker)
          elsif level == '3'
            NegamaxAI.new("AI (level #{level})", marker)
          end
        end
    end
end

#class WebReadWriteTest < CurrentUserSession

  # def test_it_redirects_to_new_game_with_root_url 
  #   get '/'
  #   follow_redirect!
  #   assert_equal "http://example.org/new_game", last_request.url
  # end

  # def test_new_game_opens_new_game_form
  #   get '/new_game' 
  #   assert last_response.ok?
  #   assert last_response.body.include?('form action="/new_game" method="POST"')
  #   assert last_response.body.include?('If Human, type your name: <input type="text" name="player2_name">')
  # end

  # def test_it_redirects_to_start_game_from_new_game 
  #   post '/new_game'
  #   follow_redirect!
  #   assert_equal "http://example.org/start_game", last_request.url
  # end

  # def test_new_game_creates_new_board
  #   new_setup
  #   assert_equal [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',], last_request.session[:board].board
  # end

  # def test_new_game_creates_new_players
  #   new_setup
  #   assert_equal [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',], last_request.session[:board].board
  #   assert_equal "test_name", last_request.session[:player1].name
  #   assert_equal Human, last_request.session[:player1].class
  #   assert_equal SequentialAI, last_request.session[:player2].class
  # end

  # def test_it_redirects_to_new_game_when_play_again_selected 
  #   post '/game_over', {"play_again" => "Yes"}
  #   follow_redirect!
  #   assert last_response.ok?
  #   assert_equal "http://example.org/new_game", last_request.url
  # end

  # def test_it_says_Goodbye_when_play_again_not_selected_2 
  #   post '/game_over', {"play_again" => "No"}
  #   assert last_response.ok?
  #   assert_equal 'Goodbye!', last_response.body
  # end

#end
