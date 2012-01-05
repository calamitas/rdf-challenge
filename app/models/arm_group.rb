class ArmGroup < Neo4j::Rails::Model
  
 include RegisteredProperties
 
 registered_properties "description", "arm_group_type", "arm_group_label", "arm_group_id"
 registered_relations 
 display_property "description"
 
end
