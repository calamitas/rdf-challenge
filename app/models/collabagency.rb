class Collabagency < Neo4j::Rails::Model
  
 include RegisteredProperties
 
 registered_properties "collaborator_agency_name", "collaborator_agency_id"
 registered_relations 
 display_property "collaborator_agency_name"
 
end
