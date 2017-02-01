class PaymentsController < ApplicationController

	include Crypto

	skip_before_action :verify_authenticity_token, only: [:create, :ccavResponseHandler, :pay]
	# skip_before_filter :verify_authenticity_token

	# helper_method :prepareMerchantDataFromArray, :prepareMerchantDataFromHash

	# include Crypto
	def index
	end

	def new
	end

	def update
		ccavResponseHandler
	end

	def destroy
	end

	def edit
	end

	def show
	end

	def sample
		render 'sampleInput'
	end

	def create
		@encrypted_url = prepare_encrypted_url(params['customer_info'])
		render 'ccavRequestHandler'
	end

	def ccavResponseHandler
		working_key="#{ENV['WORKING_KEY']}"#Put in the 32 Bit Working Key provided by CCAVENUES.
		enc_response=params[:encResp]
		# crypto = Crypto.new
		dec_resp = Crypto.decrypt(enc_response,working_key);
		dec_resp = dec_resp.split("&")

		url = prepare_response_url dec_resp

		redirect_to url
	end

	def pay
		@logger = Logger.new('logfile.log')
		@encrypted_url = prepare_encrypted_url(params['customer_info'])
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

	def prepare_encrypted_url(params)
		merchant_data="merchant_id=#{ENV['MERCHANT_ID']}"
		working_key="#{ENV['WORKING_KEY']}"   #Put in the 32 Bit Working Key provided by CCAVENUES.

		merchant_data += "&currency=INR&redirect_url=http://test.machpay.com/payments/ccavResponseHandler&cancel_url=http://test.machpay.com/payments/ccavResponseHandler&integration_type=iframe_normal&language=EN&merchant_param1=#{request.referer}&amount=#{params[:total]}&order_id=#{params[:invoice_id]}&"

		billing = {}
		billing['billing_name']= params['first_name']+' '+params['last_name']
		billing['billing_address'] = params['address_1']+', '+ params['address_2']
		billing['billing_city'] = params['city']
		billing['billing_state'] = params['state']
		billing['billing_zip'] = params['zip']
		billing['billing_country'] = params['country_name']
		billing['billing_tel'] = params['phone']
		billing['billing_email'] = params['email']

		billing.each do |key, value|
			merchant_data += key+'='+value+'&'
		end

		@logger.info("URL: #{merchant_data}")
		# @merchant_data = merchant_data
		Crypto.encrypt(merchant_data,working_key)
	end
end
