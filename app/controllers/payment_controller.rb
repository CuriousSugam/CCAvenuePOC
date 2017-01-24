class PaymentController < ApplicationController

	skip_before_action :verify_authenticity_token, only: [:create, :ccavResponseHandler]
	# skip_before_filter :verify_authenticity_token

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
		workingKey="#{ENV['WORKING_KEY']}"#Put in the 32 Bit Working Key provided by CCAVENUES.
		encResponse=params[:encResp]
		crypto = Crypto.new
		decResp=crypto.decrypt(encResponse,workingKey);
		decResp = decResp.split("&")

		url = prepare_response_url decResp

		redirect_to url
	end

	def success
	end

	def test_redirect
		url = 'http://localhost:3004/success?success=true&order_id=12345&'
		# parameters = {}
		# parameters[:success] = true
		# parameters[:amount] = 12345
		# parameters[:order_id] = 789
		redirect_to url
	end

	private

	def prepare_response_url(decResp)
		parameters = {}
		decResp.each do |key|
			parameters[key.from(0).to(key.index("=")-1)] = key.from(key.index("=")+1).to(-1)
		end

		"http://localhost:3005/success?order_id=#{parameters['order_id']}&tracking_id=#{parameters['tracking_id']}&bank_ref_no=#{parameters['bank_ref_no']}&order_status=#{parameters['order_status']}&failure_message=#{parameters['failure_message']}&payment_mode=#{parameters['payment_mode']}&card_name=#{parameters['card_name']}&status_code=#{parameters['status_code']}&status_message=#{parameters['status_message']}&currencyAmount=#{parameters['currencyAmount']}"
	end
end
