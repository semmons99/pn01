require "csv"
require "delegate"
require "bigdecimal"

class Register
  class TransactionHandler < SimpleDelegator
    def initialize(trans_csv)
      @trans = parse_trans_csv(trans_csv)
      super(@trans)
    end

    def find_by_sku(sku)
      @trans.select{|t| t["sku"] == sku}
    end

    private

    def parse_trans_csv(trans_csv)
      CSV.read(trans_csv, headers: true).each_with_object([]) do |row, trans|
        amount, currency = row["amount"].split
        amount = BigDecimal.new(amount)
        trans << {
          "store"    => row["store"],
          "sku"      => row["sku"],
          "amount"   => amount,
          "currency" => currency
        }
      end
    end
  end
end
