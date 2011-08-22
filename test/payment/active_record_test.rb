require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'active_record'

ActiveRecord::Base.establish_connection :adapter  => 'sqlite3', :database => ':memory:'
ActiveRecord::Base.connection.create_table(:pays) do |t|
  t.decimal :pay_amount
  t.decimal :total_pay
  t.integer :lock_version
  t.timestamps
end

class Pay < ActiveRecord::Base
  create :pay_amount => 12.35, :total_pay => 34.57
end

class PaymentActiveRecordTest < ActiveSupport::TestCase
  def setup
    @pay = Pay.last
  end
  
  test "should respond to proxy methods" do
    assert_respond_to @pay, :payment_amount
    assert_respond_to @pay, :total_payment
  end
  
  test "proxy should be kind of Payment::Money" do
    assert_kind_of Payment::Money, @pay.payment_amount
  end
  
  test "should handle assignment" do
    @pay.payment_amount = 12.123
    assert_equal 12.12, @pay.pay_amount.to_f
  end
  
  test "should handle block assignment" do
    @pay.total_payment do |total|
      total * 2.1
    end
    assert_equal ~34.57 * 2.1, @pay.total_payment
    assert_equal (34.57 * 2.1).round(2), @pay.total_pay.to_f
  end
  
  test "should properly perform banking rounding, even" do
    @pay.payment_amount = 12.3452
    assert_equal 12.34, @pay.pay_amount.to_f
  end
  
  test "should properly perform banking rounding odd" do
    @pay.payment_amount = 12.3552
    assert_equal 12.36, @pay.pay_amount.to_f
  end
end
