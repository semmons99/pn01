require "csv"
require "nori"

class Register
  attr_reader :rates, :trans

  def initialize(rates_xml, trans_csv)
    @rates = parse_rates(rates_xml)
    @trans = parse_trans(trans_csv)
  end

  def rate_for(from, to, path = [])
    key = {from: from, to: to}
    @rates[key] ||= -> do
      subkey = @rates.keys.find do |k|
        k[:from] == from && !path.include?(key)
      end

      @rates[subkey] * rate_for(subkey[:to], to, path << subkey)
    end.call
  end

  def total_for(sku, currency)
    @trans
      .select{|t| t["sku"] == sku}
      .map do |t|
        amt, curr = t["amount"].split
        amt  = BigDecimal(amt)
        rate = BigDecimal(rate_for(curr, currency).to_s)

        (amt * rate).round(2, BigDecimal::ROUND_HALF_EVEN)
      end
      .inject(&:+)
  end

  private

  def parse_rates(rates_xml)
    entries = Nori.parse(File.read(rates_xml))["rates"]["rate"]

    entries.each_with_object({}) do |entry, rates|
      key = {from: entry["from"], to: entry["to"]}
      rates[key] = entry["conversion"].to_f
    end
  end

  def parse_trans(trans_csv)
    CSV.read(trans_csv, headers: true)
  end
end
