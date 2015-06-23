class SequentialAI

	attr_reader :name, :type

	def initialize(name)
		@name = name
		@type = 'Computer'
	end

	def determine_move(board)
		board.available_spaces.first
	end
end
