class PaymentController < ApplicationController

	# include Crypto
	def index
	end

	def create
		@crypto = Crypto.new
		render 'ccavRequestHandler'
	end

	def ccavResponseHandler
		render 'ccavResponseHandler'
	end
end
