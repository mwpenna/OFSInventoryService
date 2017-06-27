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
end