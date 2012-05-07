require 'bigdecimal'
require 'nokogiri'
require 'csv'

require_relative "register/rate"
require_relative "register/conversion_path"
require_relative "register/transaction_processor"

class Register
  def initialize(rates_xml, trans_csv)
    @tp = TransactionProcessor.new(trans_csv, rates_xml)
  end

  def total_for(sku, currency)
    @tp.total_for_sku(sku, currency)
  end
end
