Given(/^A (.*?) user exists for a company$/) do |property|
  jwtsubject = FactoryGirl.build(:jwtsubject, role: property)
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

When(/^A request to create a template is received$/) do
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: 'myTemplate', companyHref: 'http://localhost:8083/company/id/123', props: [prop1, prop2])
  @result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json, "Bearer "+ "123")
end

When(/^A request to create a template is received with missing (.*?)$/) do |field|
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: 'myTemplate', companyHref: 'http://localhost:8083/company/id/123', props: [prop1, prop2])
  body = template.create_to_hash
  body.delete(field.to_sym)
  @result = @service_client.post_to_url_with_auth("/inventory/template", body.to_json, "Bearer "+ "123")
end

When(/^A request to create a template with missing prop field (.*?) is received$/) do |field|
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: 'myTemplate', companyHref: 'http://localhost:8083/company/id/123', props: [prop1, prop2])

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
  template = FactoryGirl.build(:template, name: 'myTemplate', companyHref: 'http://localhost:8083/company/id/123', props: [prop1, prop2])
  body = template.create_to_hash
  body[field]="test"
  @result = @service_client.post_to_url_with_auth("/inventory/template", body.to_json, "Bearer "+ "123")
end

Then(/^the response should have a status of (\d+)$/) do |response_code|
  expect(@result.response.code.to_i).to eql response_code.to_i
end

And(/^I should see the location header populated$/) do
  expect(@result.headers['location']).to_not be_nil
end
