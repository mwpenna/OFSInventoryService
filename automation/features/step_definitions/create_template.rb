Given(/^A (.*?) user exists for a company$/) do |property|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: property, companyHref: "http://localhost:8080/company/id/" + @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^User authenticate service returns an exception$/) do
  request = '{"status": 500, "message": "Internal Service Error"}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^A ADMIN user does not exists for a company$/) do
  request = '{"status": 403, "message": ""}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^A ADMIN user and template exists for a company$/) do
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  @template.companyId = @companyId
  @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json, "Bearer "+ "123")
end

When(/^A request to create a duplicate template name is received$/) do
  sleep(1)
  prop1 = FactoryGirl.build(:prop, name: 'field', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'numberField', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: @template.name, props: [prop1, prop2])
  @result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json, "Bearer "+ "123")
end

When(/^A request to create a template is received$/) do
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  @result = @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json, "Bearer "+ "123")
  @location = @result.headers['location']
end

When(/^A request to create a template is received with missing (.*?)$/) do |field|
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  body = template.create_to_hash
  body.delete(field.to_sym)
  @result = @service_client.post_to_url_with_auth("/inventory/template", body.to_json, "Bearer "+ "123")
end

When(/^A request to create a template with missing prop field (.*?) is received$/) do |field|
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])

  template.props.each_with_index {|val, index|
    prop = val.create_hash
    prop.delete(field.to_sym)
    template.props[index] = FactoryGirl.build(:prop, name: prop[:name], required: prop[:required], type: prop[:type])
  }
  @result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json, "Bearer "+ "123")
end

When(/^A request to create a template is received with field not allowed (.*?)$/) do |field|
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  body = template.create_to_hash
  body[field]="test"
  @result = @service_client.post_to_url_with_auth("/inventory/template", body.to_json, "Bearer "+ "123")
end

When(/^A request to create a template is received with a companyId$/) do
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  companyId = SecureRandom.uuid
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2], companyId: companyId)
  @result = @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json_with_company_id, "Bearer "+ "123")
  @location = @result.headers['location']
end

Then(/^the response should have a status of (\d+)$/) do |response_code|
  expect(@result.response.code.to_i).to eql response_code.to_i
end

And(/^I should see the location header populated$/) do
  expect(@result.headers['location']).to_not be_nil
end

And(/^I should see an error message with (.*?) not allowed/) do |property|
  expect(@result["errors"][0]).to eql Errors.field_not_acceptable(property)
end

And(/^I should see an error message with (.*?) missing$/) do |property|
  expect(@result["errors"][0]).to eql Errors.required_field_missing(property)
end

And(/^I should see an error message indicating prop (.*?) missing$/) do |property|
  expect(@result["errors"][0]).to eql Errors.props_required_field_missing(property)
end

Then(/^I should the template was created$/) do
  result = @service_client.get_by_url_with_auth(@location, 'Bearer 123')

  expect(result["companyId"]).to eql @companyId
  expect(result["name"]).to eql @template.name
  expect(result["createdOn"]).to_not be_nil
  expect(result["id"]).to_not be_nil
  expect(result["href"]).to_not be_nil
  expect(result["props"]).to_not be_nil

  result["props"].each do |property|
    prop = @template.props.detect{|u| u.name == property['name']}
    expect(prop.name).to eql prop.name
    expect(prop.required).to eql prop.required
    expect(prop.type).to eql prop.type
  end
end

Then(/^I should see the companyId is equal to the user companyId$/) do
  result = @service_client.get_by_url_with_auth(@location, 'Bearer 123')

  expect(result["companyId"]).to eql @companyId
  expect(result["name"]).to eql @template.name
  expect(result["createdOn"]).to_not be_nil
  expect(result["id"]).to_not be_nil
  expect(result["href"]).to_not be_nil
  expect(result["props"]).to_not be_nil

  result["props"].each do |property|
    prop = @template.props.detect{|u| u.name == property['name']}
    expect(prop.name).to eql prop.name
    expect(prop.required).to eql prop.required
    expect(prop.type).to eql prop.type
  end
end

Then(/^I should see the companyId is equal to the requested companyId$/) do
  result = @service_client.get_by_url_with_auth(@location, 'Bearer 123')

  expect(result["companyId"]).to eql @template.companyId
  expect(result["name"]).to eql @template.name
  expect(result["createdOn"]).to_not be_nil
  expect(result["id"]).to_not be_nil
  expect(result["href"]).to_not be_nil
  expect(result["props"]).to_not be_nil

  result["props"].each do |property|
    prop = @template.props.detect{|u| u.name == property['name']}
    expect(prop.name).to eql prop.name
    expect(prop.required).to eql prop.required
    expect(prop.type).to eql prop.type
  end
end
