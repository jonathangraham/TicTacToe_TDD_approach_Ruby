class Human

	attr_accessor :name, :interface, :position, :marker

	def initialize(interface, name, marker)
		@name = name
		@interface = interface
		@marker = marker
		@position = -1
	end

end

class ConsoleHuman < Human

	def determine_move(board)
		interface.get_human_move()
	end
	
end

class WebHuman < Human

	def determine_move(board)
		@position
	end

end
