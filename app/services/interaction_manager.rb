class InteractionManager
	def initialize(options)
		@actor = options[:actor]
		@receiver = options[:receiver]
	end

	def view()
		@actor.view(@receiver)
	end

	def like()
		@actor.like(@receiver)
	end
end