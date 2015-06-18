class SequentialAI

	attr_reader :name

	def initialize(name)
		@name = name
	end

	def determine_move(board)
		board.available_spaces.first
	end
end
