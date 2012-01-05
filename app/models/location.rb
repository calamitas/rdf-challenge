class Location < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "facility_address_zip", "location_id", "facility_name", "facility_address_country", "facility_address_city", "facility_address_state"
  registered_relations 
  display_property { [facility_address_city, facility_address_zip, facility_address_state, facility_address_country].compact.join(", ") }
  
end
