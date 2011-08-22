require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PaymentMoneyTest < ActiveSupport::TestCase
  test "conversion" do
    assert_instance_of(Payment::Money, ~0.2)
  end
  
  test "precision" do
    assert_equal(~0.2 - 0.05 - 0.15, 0.0)
  end
  
  test "operators" do
    assert_instance_of(Payment::Money, ~0.2 - 0.05)
    assert_instance_of(Payment::Money, ~0.2 + 0.05)
    assert_instance_of(Payment::Money, ~0.2 * 0.05)
    assert_instance_of(Payment::Money, ~0.2 / 0.05)
  end
  
  test "representation" do
    assert_not_nil((~12.345678).to_str =~ /\.\d{2}$/)
  end
end
