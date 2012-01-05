class ModelTypes
  
  include FakeProperties
  include RegisteredProperties
  
  registered_properties "name"
  registered_relations "arm_group", "collabagency", "condition", "intervention", "link", "location", "overall_official", "oversight", "primary_outcomes", "reference", "results_reference", "secondary_outcomes", "trials"
  display_property "name"
  
  attr_reader :rdf_url
  
  def initialize(rdf_url)
    @rdf_url = rdf_url
  end
  
  def id
    "root"
  end
  
  def name
    "Types"
  end
  
  def outgoing(name)
    case name
    when *self.class.registered_relations
      name.camelize.constantize.all
    end
  end
  
end
