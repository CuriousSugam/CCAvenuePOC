module PaymentsHelper
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
