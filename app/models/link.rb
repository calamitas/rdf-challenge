class Link < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "link_id", "description"
  registered_relations 
  display_property "description"
  
end
