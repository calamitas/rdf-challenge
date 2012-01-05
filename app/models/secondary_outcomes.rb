class SecondaryOutcomes < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "measure", "safety_issue", "time_frame", "secondary_outcomes_id"
  registered_relations 
  display_property "measure"
  
end
