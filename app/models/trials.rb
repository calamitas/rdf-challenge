class Trials < Neo4j::Rails::Model
  
  include RegisteredProperties
  
  registered_properties "eligibility_minimum_age", "brief_title", "nct_id", "number_of_arms", "number_of_groups", "id", "download_date", "enrollment", "nct_alias", "firstreceived_date", "eligibility_healthy_volunteers", "eligibility_study_pop", "overall_status", "summary", "primary_completion_date", "end_date", "acronym", "official_title", "source", "verification_date", "biospec", "biospec_retention", "eligibility_gender", "org_study_id", "lead_sponsor_agency", "criteria", "study_design", "overall_contact_email", "overall_contact_phone_ext", "secondary_id", "start_date", "overall_contact_last_name", "study_type", "eligibility_sampling_method", "overall_contact_phone", "phase", "description", "why_stopped", "has_dmc", "lastchanged_date", "eligibility_maximum_age"
  registered_relations "oversight", "results_reference", "arm_group", "condition", "location", "reference", "secondary_outcomes", "link", "intervention", "overall_official", "collaborator_agency", "primary_outcomes"
  display_property "id"
  
end
