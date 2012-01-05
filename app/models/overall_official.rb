class OverallOfficial < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "last_name", "overall_official_id", "affiliation"
  registered_relations 
  display_property "last_name"
  
end
