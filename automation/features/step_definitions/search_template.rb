Given(/^A (.*?) user exists and templates exists with different prop names for a company$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'SYSTEM_ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)

  @templates = []

    prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
    prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
    template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2], companyId:  @companyId)
    result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json_with_company_id, "Bearer "+ "123")
    location = result.headers['location']
    template.id = location.split("/id/").last
    @templates << template

    prop1 = FactoryGirl.build(:prop, name: 'stringValue', required: true, type:'STRING')
    prop2 = FactoryGirl.build(:prop, name: 'numValue', required: true, type:'NUMBER')
    template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2], companyId:  @companyId)
    result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json_with_company_id, "Bearer "+ "123")
    location = result.headers['location']
    template.id = location.split("/id/").last
    @templates << template


  sleep(2)
  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

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

When(/^A request to search for a template is received with both prop search parameter and name parameter$/) do
  prop = {}
  prop[:name] = @templates[0].props[0].create_hash[:name]
  body = {name: @templates[0].name, props: [prop]}
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", body.to_json, "Bearer "+ "123")
  @templates = [@templates[0]]
end


When(/^A request to search for templates is received$/) do
  body = {name: "test"}
  @result = @service_client.post_to_url_with_auth("/inventory/template/search", body.to_json, "Bearer "+ "123")
end