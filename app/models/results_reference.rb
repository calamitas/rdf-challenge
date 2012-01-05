class ResultsReference < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "results_reference_id", "PMid", "citation"
  registered_relations 
  display_property "citation"
  
end
