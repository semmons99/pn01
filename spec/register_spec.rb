require_relative "../lib/register"

RATES = File.dirname(__FILE__) + "/../data/SAMPLE_RATES.xml"
TRANS = File.dirname(__FILE__) + "/../data/SAMPLE_TRANS.csv"

describe Register do
  subject { Register.new(RATES, TRANS) }

  describe "#new" do
    it "parses the rates xml" do
      subject.rates[{from: "AUD", to: "CAD"}].should eq(1.0079)
    end

    it "parses the trans csv" do
      subject.trans[0]["store"].should eq("Yonkers")
    end
  end

  describe "#rate_for" do
    it "returns known rates" do
      rate = subject.rate_for("AUD", "CAD")
      rate.should eq(1.0079)
    end

    it "derives unknown rates" do
      rate = subject.rate_for("AUD", "USD")
      rate.should eq(1.0169711)
    end

    it "caches derived rates" do
      subject.rates[{from: "AUD", to: "USD"}].should be_nil
      subject.rate_for("AUD", "USD")
      subject.rates[{from: "AUD", to: "USD"}].should eq(1.0169711)
    end
  end

  describe "#total_for" do
    it "calculates the total of sku/currency" do
      total = subject.total_for("DM1182", "USD")
      total.should eq(134.22)
    end
  end
end
