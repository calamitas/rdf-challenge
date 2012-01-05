module RegisteredProperties
  
  module ClassMethods
  
    def registered_properties(*names)
      if names.empty?
        @registered_properties ||= []
      else
        names.each { |name| property name }
        (@registered_properties ||= []).concat(names)
      end
    end
    
    def registered_relations(*relations)
      if relations.empty?
        @registered_relations ||= []
      else
        relations.each { |relation| has_n relation }
        (@registered_relations ||= []).concat(relations)
      end
    end
    
    def display_property(name = nil, &blk)
      if name || blk
        @display_property = name || blk
      else
        @display_property ||= "rdf_url"
      end
    end
    
  end
  
  def display_property
    prop = self.class.display_property
    if Proc === prop
      instance_eval(&prop)
    else
      self[prop]
    end
  end
  
  def self.included(cl)
    cl.extend(RegisteredProperties::ClassMethods)
    cl.registered_properties("rdf_url")
  end
  
end
