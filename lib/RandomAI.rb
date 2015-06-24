class RandomAI

	attr_reader :name, :type

	def initialize(name)
		@name = name
		@type = 'Computer'
	end

	def determine_move(board)
		position = generate_random_position(board)
		until board.valid_space?(position) do
			position = generate_random_position(board)
		end
		position
	end

	private

		def generate_random_position(board)
			rand(board.board.length)
		end
end
