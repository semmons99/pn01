class Register
  class Rate
    attr_reader :from, :to

    def initialize(rates_xml, from, to)
      @conversion_path = ConversionPath.new(rates_xml, from, to)
      @from            = from
      @to              = to
      @value           = BigDecimal("1") if from == to
    end

    def value  
      @value ||= @conversion_path.inject(BigDecimal("1")) do |rate, node|
        rate * node.exchange_rate
      end
    end
  end
end
