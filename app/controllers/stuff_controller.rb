class StuffController < ApplicationController
	layout false
	
	def blitz
		render text: 42
	end
end