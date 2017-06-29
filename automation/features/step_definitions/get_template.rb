Given(/^A (.*?) user exists and template exists for a company$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  result = @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json, "Bearer "+ "123")
  @location = result.headers['location']
  @template.companyId = @companyId
  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^A (.*?) user exists and template exists for a different company$/) do |role|
  companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'SYSTEM_ADMIN', companyHref: 'http://localhost:8080/company/id/'+ companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  result = @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json, "Bearer "+ "123")
  @location = result.headers['location']
  companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

When(/^A request to get the template is received$/) do
  @result = @service_client.get_by_url_with_auth(@location, 'Bearer 123')
end

When(/^A request to get a template that does not exists is received$/) do
  @result = @service_client.get_by_url_with_auth(@service_client.get_base_uri+'/inventory/template/id/123', 'Bearer 123')
end

When(/^A request to get a template is received$/) do
  @result = @service_client.get_by_url_with_auth(@service_client.get_base_uri+'/inventory/template/id/123', 'Bearer 123')
end

Then(/^I should see the template was returned$/) do
  expect(@result["companyId"]).to eql @template.companyId
  expect(@result["name"]).to eql @template.name
  expect(@result["createdOn"]).to_not be_nil
  expect(@result["id"]).to_not be_nil
  expect(@result["href"]).to_not be_nil
  expect(@result["props"]).to_not be_nil

  @result["props"].each do |property|
    prop = @template.props.detect{|u| u.name == property['name']}
    expect(prop.name).to eql prop.name
    expect(prop.required).to eql prop.required
    expect(prop.type).to eql prop.type
  end
end