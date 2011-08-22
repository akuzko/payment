module Payment
  PRECISION = 12
  EPSILON = "1e-#{PRECISION}".to_f
  
  autoload :Float, 'payment/float'
  autoload :Money, 'payment/money'
  autoload :ActiveRecord, 'payment/active_record'
end
