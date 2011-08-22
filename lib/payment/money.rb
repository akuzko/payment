require 'delegate'

class Payment::Money < DelegateClass Float
  def initialize obj
    super(obj.to_f.round(Payment::PRECISION))
    @dc_name = instance_variables.first
  end
  
  %w(% * ** + - /).each do |operator|
    define_method operator do |other|
      Payment::Money.new(super(other).round(Payment::PRECISION))
    end
  end
  
  def -@
    Payment::Money.new super
  end
  
  def ~@
    dc_obj
  end
  
  def to_str
    "%.2f" % rounded
  end
  
  def calculations
    self.dc_obj = (yield dc_obj).round(Payment::PRECISION)
  end
  
  def rounded
    int = (dc_obj * 1000).floor
    int = int + ((int / 10).even? ? -5 : 5) if int % 10 == 5
    (int.to_f / 1000).round(2)
  end
  
  private
  
  def dc_obj
    instance_variable_get(@dc_name)
  end
  
  def dc_obj= val
    instance_variable_set(@dc_name, val)
  end
end