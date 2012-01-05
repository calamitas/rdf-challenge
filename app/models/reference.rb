class Reference < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "PMid", "reference_id", "citation"
  registered_relations 
  display_property "citation"
  
end
