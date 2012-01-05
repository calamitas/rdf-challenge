class Intervention < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "intervention_name", "intervention_id", "intervention_type", "description"
  registered_relations 
  display_property "intervention_name"
  
end
