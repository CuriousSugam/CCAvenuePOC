class PaymentsController < ApplicationController

	skip_before_action :verify_authenticity_token, only: [:create, :ccavResponseHandler, :pay]
	# skip_before_filter :verify_authenticity_token

	# helper_method :prepareMerchantDataFromArray, :prepareMerchantDataFromHash

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
		working_key="#{ENV['WORKING_KEY']}"#Put in the 32 Bit Working Key provided by CCAVENUES.
		enc_response=params[:encResp]
		crypto = Crypto.new
		dec_resp=crypto.decrypt(enc_response,working_key);
		dec_resp = dec_resp.split("&")

		url = prepare_response_url dec_resp

		redirect_to url
	end

	def pay
		@crypto = Crypto.new
		render 'ccavRequestHandler'
	end

	def success

	end

	def test_redirect
		# url = 'http://localhost:3004/success?success=true&order_id=12345&'
		# parameters = {}
		# parameters[:success] = true
		# parameters[:amount] = 12345
		# parameters[:order_id] = 789
		# redirect_to url
	end

	private

	def prepare_response_url(dec_resp)
		parameters = {}
		dec_resp.each do |key|
			parameters[key.from(0).to(key.index("=")-1)] = key.from(key.index("=")+1).to(-1)
		end

		"http://localhost:3005/success?order_id=#{parameters['order_id']}&tracking_id=#{parameters['tracking_id']}&bank_ref_no=#{parameters['bank_ref_no']}&order_status=#{parameters['order_status']}&failure_message=#{parameters['failure_message']}&payment_mode=#{parameters['payment_mode']}&card_name=#{parameters['card_name']}&status_code=#{parameters['status_code']}&status_message=#{parameters['status_message']}&currencyAmount=#{parameters['currencyAmount']}"
	end
end
