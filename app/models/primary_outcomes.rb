class PrimaryOutcomes < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "primary_outcomes_id", "safety_issue", "time_frame", "measure"
  registered_relations 
  display_property "measure"
  
end
