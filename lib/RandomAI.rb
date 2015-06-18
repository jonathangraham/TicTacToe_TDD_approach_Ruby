class RandomAI

	attr_reader :name

	def initialize(name)
		@name = name
	end

	def generate_random_position(board)
		rand(board.board.length)
	end

	def determine_move(board)
		position = generate_random_position(board)
		until board.empty_space?(position) || board.tie? do
			position = generate_random_position(board)
		end
		position
	end
end