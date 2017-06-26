Given(/^A SYSTEM_ADMIN user exists for a company$/) do
  jwtsubject = FactoryGirl.build(:jwtsubject, role:'SYSTEM_ADMIN')
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url('http://localhost:4567/users/authenticate/status', request)
end

When(/^A request to create a template is received$/) do
  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  template = FactoryGirl.build(:template, name: 'myTemplate', companyHref: 'http://localhost:8083/company/id/123', props: [prop1, prop2])
  @result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json, "Bearer "+ "123")
end

Then(/^the response should have a status of (\d+)$/) do |response_code|
  expect(@result.response.code.to_i).to eql response_code.to_i
end

And(/^I should see the location header populated$/) do
  expect(@result.headers['location']).to_not be_nil
end
