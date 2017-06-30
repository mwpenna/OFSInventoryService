Given(/^A (.*?) user exists and templates exists for a company$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'SYSTEM_ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)

  @templates = []
  rand(2..5).times do
    prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
    prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
    template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2], companyId:  @companyId)
    result = @service_client.post_to_url_with_auth("/inventory/template", template.create_to_json_with_company_id, "Bearer "+ "123")
    location = result.headers['location']
    template.id = location.split("/id/").last
    @templates << template
  end

  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^A company exists without templates$/) do
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

When(/^A request to get the templates by company id is received$/) do
  @companyId ||= SecureRandom.uuid
  @result = @service_client.get_by_url_with_auth(@service_client.get_base_uri + '/inventory/template/company/id/' + @companyId, "Bearer 123")
end

When(/^A request to get the template for a company id that does not exists is received$/) do
  @result = @service_client.get_by_url_with_auth(@service_client.get_base_uri + '/inventory/template/company/id/' + SecureRandom.uuid, "Bearer 123")
end

Then(/^I should see the template list was returned$/) do
  expect(@result["count"]).to eql @templates.size
  expect(@result["items"].size).to eql @templates.size

  @result["items"].each do |response|
    template = @templates.detect{|t| t.id == response['id']}
    expect(response["companyId"]).to eql template.companyId
    expect(response["name"]).to eql template.name
    expect(response["createdOn"]).to_not be_nil
    expect(response["id"]).to_not be_nil
    expect(response["href"]).to_not be_nil
    expect(response["props"]).to_not be_nil

    response["props"].each do |property|
      prop = template.props.detect{|u| u.name == property['name']}
      expect(prop.name).to eql prop.name
      expect(prop.required).to eql prop.required
      expect(prop.type).to eql prop.type
    end
  end
end

Then(/^I should see an empty list was returned$/) do
  expect(@result["count"]).to eql 0
  expect(@result["items"].size).to eql 0
end