require_relative "../lib/register/transaction_handler"

TRANS = File.dirname(__FILE__) + "/../data/SAMPLE_TRANS.csv"

describe Register::TransactionHandler do
  subject { Register::TransactionHandler.new(TRANS) }

  describe "#new" do
    it "splits the amount column into amount/currency" do
      trans = subject.first
      trans["amount"].should   eq(70.00)
      trans["currency"].should eq("USD")
    end
  end

  describe "#find_by_sku" do
    it "returns all transactions with a specific sku" do
      trans = subject.find_by_sku("DM1182")
      trans.size.should eq(3)
    end
  end
end
