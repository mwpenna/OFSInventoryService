Given(/^A (.*?) user and template exists$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'SYSTEM_ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)

  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  template.companyId = @companyId
  result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json, "Bearer "+ "123")
  location = result.headers['location']
  @templateId = location.split("/id/").last

  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

When(/^A request is made to delete the template$/) do
  @templateId ||= SecureRandom.uuid
  @result = @service_client.delete_by_url_with_auth(@service_client.get_base_uri + '/inventory/template/id/' + @templateId, 'Bearer 123')
end

When(/^A request is made to delete a template the does not exists$/) do
  @result = @service_client.delete_by_url_with_auth(@service_client.get_base_uri + '/inventory/template/id/' + SecureRandom.uuid, 'Bearer 123')
end

Then(/^I should see the template does not exists$/) do
  result = @service_client.delete_by_url_with_auth(@service_client.get_base_uri + '/inventory/template/id/' + @templateId, 'Bearer 123')
  expect(result.response.code.to_i).to eql 404
end