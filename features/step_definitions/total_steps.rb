require_relative "../../lib/register"

Given /^a (.*) file (.*)$/ do |type, file|
  file = File.dirname(__FILE__) + "/../../" + file
  instance_variable_set("@#{type}", file)
end

When /^I calculate the total for (.*) in (.*)$/ do |sku, currency|
  register = Register.new(@rates, @trans)
  @total   = register.total_for(sku, currency)
end

Then /^I get \$(.*)$/ do |total|
  total = total.to_f
  @total.should eq(total)
end
