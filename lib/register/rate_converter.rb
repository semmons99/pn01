require "nori"
require "bigdecimal"

class Register
  Rate = Struct.new(:from, :to, :amt)

  class RateConverter
    def initialize(rates_xml)
      @rates = parse_rates_xml(rates_xml)
    end

    def rate_for(from, to, path = [])
      rate = @rates.find{|rate| rate.from == from && rate.to == to}
      return rate.amt unless rate.nil?

      rate = @rates.find{|rate| rate.from == from && !path.include?(rate)}
      rate.amt * rate_for(rate.to, to, path << rate)
    end

    def convert(trans, to)
      rate   = rate_for(trans["currency"], to)
      (trans["amount"] * rate).round(2, BigDecimal::ROUND_HALF_EVEN)
    end

    private

    def parse_rates_xml(rates_xml)
      entries = Nori.parse(File.read(rates_xml))["rates"]["rate"]

      entries.map do |entry|
        Rate.new( entry["from"], entry["to"], BigDecimal(entry["conversion"]))
      end
    end
  end
end
