ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require '/Users/jonathangraham/TTT_TDD/lib/WebReadWrite'
require '/Users/jonathangraham/TTT_TDD/lib/Board'
require '/Users/jonathangraham/TTT_TDD/lib/SequentialAI'
require '/Users/jonathangraham/TTT_TDD/lib/RandomAI'
require '/Users/jonathangraham/TTT_TDD/lib/NegamaxAI'
require '/Users/jonathangraham/TTT_TDD/lib/Human'
require '/Users/jonathangraham/TTT_TDD/lib/Game'


class CurrentUserSession < Minitest::Test
  include Rack::Test::Methods
 
  def app
    Sinatra::Application
  end

  def new_setup
    post'/new_game', {"player1" => "Human", "player1_name" => "test_name", "player1_level" => "Easy", 
      "player2" => "Computer", "player2_name" => "Easy", "player2_level" => "Easy",
      "board_size" => "3", "win_size" => "3"}
  end

end

class WebReadWriteTest < CurrentUserSession

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

  def test_it_redirects_to_start_game_from_new_game 
    post '/new_game'
    follow_redirect!
    assert_equal "http://example.org/start_game", last_request.url
  end

  def test_new_game_creates_new_board
    new_setup
    assert_equal [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',], last_request.session[:board].board
  end

  def test_new_game_creates_new_players
    new_setup
    assert_equal [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',], last_request.session[:board].board
    assert_equal "test_name", last_request.session[:player1].name
    assert_equal Human, last_request.session[:player1].class
    assert_equal SequentialAI, last_request.session[:player2].class
  end

  def test_it_redirects_to_new_game_when_play_again_selected 
    post '/game_over', {"play_again" => "Yes"}
    follow_redirect!
    assert last_response.ok?
    assert_equal "http://example.org/new_game", last_request.url
  end

  def test_it_says_Goodbye_when_play_again_not_selected_2 
    post '/game_over', {"play_again" => "No"}
    assert last_response.ok?
    assert_equal 'Goodbye!', last_response.body
  end

end
