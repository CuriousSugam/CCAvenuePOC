class PaymentController < ApplicationController

	skip_before_action :verify_authenticity_token, only: [:create]

	# include Crypto
	def index
	end

	def sample
		render 'sampleInput'
	end

	def create
		@crypto = Crypto.new
		render 'ccavRequestHandler'
	end

	def ccavResponseHandler
		render 'ccavResponseHandler'
	end

	# def ccavRequestHandler
	# 	render 'ccavRequestHandler'
	# end
end
