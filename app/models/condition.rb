class Condition < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "condition_id", "condition_name"
  registered_relations 
  display_property "condition_name"
  
end
