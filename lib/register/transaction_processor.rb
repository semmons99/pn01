class Register
  class TransactionProcessor

    def initialize(trans_csv, rates_xml)
      @trans = CSV.read(trans_csv, :headers => true)
      @rates = Hash.new{|h,k|
                 h[k] = Rate.new(rates_xml, k[:from], k[:to])
               }
    end

    def total_for_sku(sku, in_currency)
      txs = @trans.select{|tx| tx["sku"] == sku}
      txs.inject(BigDecimal("0")){|sum, tx| sum + normalize(tx, in_currency)}
    end

    private

    def normalize(tx, to)
      amt, from = tx["amount"].split

      amt = BigDecimal(amt)
      rate = @rates[{:from => from, :to => to}].value

      round(amt * rate)
    end

    def round(n)
      cents     = n * BigDecimal("100")
      remainder = cents % BigDecimal("1")

      if remainder == BigDecimal("0")
        n
      elsif remainder < BigDecimal("0.5")
        n.round(2, BigDecimal::ROUND_DOWN)
      elsif remainder > BigDecimal("0.5")
        n.round(2, BigDecimal::ROUND_UP)
      elsif cents.even?
        n.round(2, BigDecimal::ROUND_DOWN)
      else
        n.round(2, BigDecimal::ROUND_UP)
      end
    end
  end
end
