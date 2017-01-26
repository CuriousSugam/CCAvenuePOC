module PaymentsHelper

  def encrypted_url
    merchant_data="merchant_id=#{ENV['MERCHANT_ID']}"
    working_key="#{ENV['WORKING_KEY']}"   #Put in the 32 Bit Working Key provided by CCAVENUES.
    referer = request.referer

    amount = params[:total]
    order_id = params[:invoice_id]

    merchant_data += "&currency=INR&redirect_url=https://test.machpay.com/payments/ccavResponseHandler&cancel_url=https://test.machpay.com/payments/ccavResponseHandler&integration_type=iframe_normal&language=EN&merchant_param1=#{referer}&amount=#{amount}&order_id=#{order_id}&"

    billing = {}

    temp = params['customer_info']

    billing['name']= temp['first_name']+' '+temp['last_name']
    billing['address'] = temp['address_1']+', '+ temp['address_2']
    billing['city'] = temp['city']
    billing['state'] = temp['state']
    billing['zip'] = temp['zip']
    billing['country'] = temp['country_name']
    billing['tel'] = temp['phone']
    billing['email'] = temp['email']

    billing.each do |key, value|
      merchant_data += key+'='+value+'&'
    end


    # params.each do |key, value|
    #   if value.is_a? String
    #     merchant_data += prepare_merchant_data(key, value)
    #   elsif value.is_a? Hash
    #     merchant_data += merchant_data_from_hash(value)
    #   elsif value.is_a? Array
    #     merchant_data += merchant_data_from_array(value)
    #   end
    # end

    @crypto.encrypt(merchant_data,working_key)
  end

  def prepare_merchant_data(key, value)
    _key = key
    if _key.eql? 'total'
      _key = 'amount'
    end
    _key+"="+value+"&"
  end

  # return string
  def merchant_data_from_array(array)
    data = ''
    array.each do |item|
      if item.is_a? Hash
        item.each do |key, value|
          data += prepare_merchant_data(key, value)
        end

      end
    end
    data
  end

  # return string
  def merchant_data_from_hash(input_hash)

    data = ''
    input_hash.each do |key, value|
      data += prepare_merchant_data(key, value)
    end
    data
  end
end
