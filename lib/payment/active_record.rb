module Payment::ActiveRecord
  extend ActiveSupport::Concern
  
  included do
    singleton_class.class_eval do
      def inherited_with_payment base
        inherited_without_payment base
        base.column_names.grep(/^pay_|_pay$/).each do |name|
          proxy_name = name.sub(/^pay|pay$/, 'payment')
          define_payment_proxy_methods name, proxy_name
        end
      end
      alias_method_chain :inherited, :payment
    end
  end
  
  module ClassMethods
    private
    
    def define_payment_proxy_methods name, proxy_name
      define_method proxy_name do |&block|
        money = instance_variable_get("@payment_#{name}") || instance_variable_set("@payment_#{name}", Payment::Money.new(self[name].to_f))
        send("#{proxy_name}=", money.calculations(&block)) if block
        money
      end
      
      define_method "#{proxy_name}=" do |value|
        money = instance_variable_set("@payment_#{name}", value.class == Payment::Money ? value : Payment::Money.new(value))
        self[name] = money.rounded
      end
    end
  end
end
