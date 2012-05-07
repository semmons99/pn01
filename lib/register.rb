require_relative "register/rate_converter"
require_relative "register/transaction_handler"

class Register
  def initialize(rates_xml, trans_csv)
    @rates = RateConverter.new(rates_xml)
    @trans = TransactionHandler.new(trans_csv)
  end

  def total_for(sku, currency)
    @trans
      .find_by_sku(sku)
      .map{|t| @rates.convert(t, currency)}
      .inject(&:+)
  end
end
