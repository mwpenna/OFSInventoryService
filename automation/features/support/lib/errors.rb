class Errors
  def self.required_field_missing(field)
    {"code" => "user.#{field.underscore}.required_field_missing",
     "property" => field,
     "message" => "Validation error. Cannot create User without #{field}.",
     "developerMessage" => "Missing required field #{field.split('.').last}",
     "properties" => {"field" => field}}
  end

  def self.field_not_acceptable(field)
    {"code" => "user.#{field.underscore}.not_acceptable",
     "property" => field,
     "message" => "Validation error. Cannot create user with #{field} in request. The value of #{field} is a system-generated read-only value.",
     "developerMessage" => "instance matched a schema which it should not have",
     "properties" => {"field" => field}}
  end
end