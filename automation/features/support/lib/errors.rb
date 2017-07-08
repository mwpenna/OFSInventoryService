class Errors
  def self.required_field_missing(field)
    {"code" => "inventory-template.#{field.underscore}.required_field_missing",
     "property" => field,
     "message" => "Validation error. Cannot create template without #{field}.",
     "developerMessage" => "Missing required field #{field.split('.').last}",
     "properties" => {"field" => field}}
  end

  def self.field_not_acceptable(field)
    {"code" => "inventory-template.#{field.underscore}.not_acceptable",
     "property" => field,
     "message" => "Validation error. Cannot create template with #{field} in request. The value of #{field} is a system-generated read-only value.",
     "developerMessage" => "instance matched a schema which it should not have",
     "properties" => {"field" => field}}
  end

  def self.props_required_field_missing(field)
    {"code" => "inventory-template.props.items.#{field.underscore}.required_field_missing",
     "property" => "props.items.#{field}",
     "message" => "Validation error. Cannot create template without props.items.#{field}.",
     "developerMessage" => "Missing required field #{field.split('.').last}",
     "properties" => {"field" => "props.items.#{field}"}}
  end

  def self.inventory_required_field_missing(field)
    {"code" => "inventory.#{field.underscore}.required_field_missing",
     "property" => field,
     "message" => "Validation error. Cannot create inventory without #{field}.",
     "developerMessage" => "Missing required field #{field.split('.').last}",
     "properties" => {"field" => field}}
  end

  def self.inventory_field_not_acceptable(field)
    {"code" => "inventory.#{field.underscore}.not_acceptable",
     "property" => field,
     "message" => "Validation error. Cannot create inventory with #{field} in request. The value of #{field} is a system-generated read-only value.",
     "developerMessage" => "instance matched a schema which it should not have",
     "properties" => {"field" => field}}
  end

  def self.inventory_props_required_field_missing(field)
    {"code" => "inventory.props.items.#{field.underscore}.required_field_missing",
     "property" => "props.items.#{field}",
     "message" => "Validation error. Cannot create inventory without props.items.#{field}.",
     "developerMessage" => "Missing required field #{field.split('.').last}",
     "properties" => {"field" => "props.items.#{field}"}}
  end

  def self.inventory_required_prop_missing
    {"code"=>"inventory_required_prop_missing",
     "message"=>"Validation error. Missing required template property.",
     "developerMessage"=>"Validation error. Missing required template property."
    }
  end

  def self.inventory_prop_field_not_acceptable(field)
    {"code" => "inventory.props.items.#{field.underscore}.not_acceptable",
     "property" => "props.items.#{field}",
     "message"=>"Validation error. Cannot create inventory with props.items.#{field} in request. The value of props.items.#{field} is a system-generated read-only value.",
     "developerMessage"=>"instance matched a schema which it should not have",
     "properties"=>{"field"=>"props.items.#{field}"}}
  end

  def self.inventory_type_not_valid
    {"code"=>"inventory.type.not_valid",
     "message"=>"Validation error. Inventory type does not exists for company.",
     "developerMessage"=>"Validation error. Inventory type does not exists for company."}
  end
end