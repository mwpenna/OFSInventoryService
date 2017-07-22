When(/^A request to search for a template is received$/) do
  template = FactoryGirl.build(:template, name: @templates[0].name)
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", template.search_by_name_to_json, "Bearer "+ "123")
  @templates = [@templates[0]]
end

When(/^A request to search for a template is received with invalid search parameter (.*?)$/) do |field|
  template = FactoryGirl.build(:template, name: @templates[0].name)
  body = template.search_by_name_to_hash
  body[field] = "test"
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", body.to_json, "Bearer "+ "123")
end

When(/^A request to search for a template is received with invalid prop search parameter (.*?)$/) do |field|
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", {props: {field: "test"}}.to_json, "Bearer "+ "123")
end

When(/^A request to search for a template is received with search parameter (.*?)$/) do |field|
  body = {}
  body[field.to_sym]=@templates[0].create_to_hash[field.to_sym]
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", body.to_json, "Bearer "+ "123")
  @templates = [@templates[0]]
end

When(/^A request to search for a template is received with prop search parameter (.*?)$/) do |field|
  prop = {}
  prop[field.to_sym] = @templates[0].props[0].create_hash[field.to_sym]
  body = {props: [prop]}
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", body.to_json, "Bearer "+ "123")
  @templates = [@templates[0]]
end

When(/^A request to search for templates is received$/) do
  body = {name: "test"}
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", body.to_json, "Bearer "+ "123")
end