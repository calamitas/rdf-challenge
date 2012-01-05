class Oversight < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "oversight_oversight_info_authority", "oversight_id"
  registered_relations 
  display_property "oversight_oversight_info_authority"
  
end
