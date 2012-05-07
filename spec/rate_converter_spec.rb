require_relative "../lib/register/rate_converter"

RATES = File.dirname(__FILE__) + "/../data/SAMPLE_RATES.xml"

describe Register::RateConverter do
  subject { Register::RateConverter.new(RATES) }

  describe "#rate_for" do
    it "returns known rates" do
      rate = subject.rate_for("AUD", "CAD")
      rate.should eq(1.0079)
    end

    it "derives unknown rates" do
      rate = subject.rate_for("AUD", "USD")
      rate.should eq(1.0169711)
    end
  end

  describe "#convert" do
    it "converts a transaction" do
      amt = subject.convert(BigDecimal("20.00"), "AUD", "CAD")

      amt.should eq(20.16)
    end
  end
end
