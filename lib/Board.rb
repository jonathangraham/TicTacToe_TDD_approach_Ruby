class Board
	attr_reader :board, :index_board, :x_in_a_row

	def initialize(grid_size, x_in_a_row)
		elements = grid_size * grid_size
		@board = Array.new(elements, ' ')
		@index_board = Array(0..(elements - 1))
		@x_in_a_row = x_in_a_row
	end

	def update_board(position, letter)
		@board[position] = letter
	end

	def empty_space?(position)
		@board[position] == ' '
	end

	def tie?()
		@board.count(' ') == 0
	end

	def rows()
		rows = @board.each_slice(Math.sqrt(@board.length)).to_a
	end

	def columns()
		rows.transpose
	end

	def diaganols()
		n = rows.length
		diaganols = [right_diaganols(n), left_diaganols(n)].flatten(1)
	end

	def right_diaganols(n)
		right_diaganols = []
		row = 0
		until row == n do
			column = 0
			until column == n do
				right_diaganols << right_diaganol(row, column, n)
				column = column + 1
			end
			row = row + 1
		end
		right_diaganols
	end

	def right_diaganol(row, column, n)
		right_diaganol = []
		until row == n || column == n do
			right_diaganol << rows[row][column]
			row = row + 1
			column = column + 1
		end
		right_diaganol
	end

	def left_diaganols(n)
		left_diaganols = []
		row = 0
		until row == n do
			column = 0
			until column == n do
				left_diaganols << left_diaganol(row, column, n)
				column = column + 1
			end
			row = row + 1
		end
		left_diaganols
	end

	def left_diaganol(row, column, n)
		left_diaganol = []
		until row == n || column < 0 do
			left_diaganol << rows[row][column]
			row = row + 1
			column = column - 1
		end
		left_diaganol
	end

	def potential_winning_lines()
		rows | columns | diaganols 
	end

	def win?(marker)
		checked_lines = potential_winning_lines().map do |innerArray|
			winning_line?(innerArray, marker).include? true
		end
		checked_lines.include? true
	end

	def winning_line?(innerArray, marker)
		arr_booleans = []
		innerArray.map do |e|
			if e == marker
				arr_booleans << true
			else
				arr_booleans = []
			end
			arr_booleans.length >= @x_in_a_row
		end
	end

	def game_end?()
		marker = marker_just_played()
		win?(marker) || tie?()
	end

	def marker_just_played()
		if (@board.length - @board.count(' '))%2 == 0
			'O'
		else
			'X'
		end
	end

	def marker_to_play_next()
		marker_just_played() == 'O' ? 'X' : 'O'
	end

	def available_spaces()
		@board.each_index.select{|i| @board[i] == ' '}
	end

	def valid_space?(position)
		@board[position] == ' ' && @index_board.include?(position)
	end
end
