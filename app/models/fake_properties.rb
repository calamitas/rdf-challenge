module FakeProperties
  
  module ClassMethods
    
    def property(name)
    end
    
    def has_n(name)
    end
    
  end
  
  def [](name)
    send(name)
  end
  
  def self.included(cl)
    cl.extend(FakeProperties::ClassMethods)
  end
  
end
