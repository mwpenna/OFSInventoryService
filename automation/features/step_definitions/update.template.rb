Given(/^A ADMIN user exists and template does not exists$/) do
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: "http://localhost:8080/company/id/" + @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

When(/^A request to update a template is received$/) do
  @template ||= FactoryGirl.build(:template, name: Faker::Name.name)
  @template.id ||= SecureRandom.uuid
  @template.name = Faker::Name.name
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.create_to_json, "Bearer "+ "123")
end

When(/^A request to update a template that does not exists is received$/) do
  template = FactoryGirl.build(:template, name: Faker::Name.name)
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+SecureRandom.uuid.to_s, template.create_to_json, "Bearer "+ "123")
end

When(/^A request to update a template name is received$/) do
  @template.name = Faker::Name.name
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_name_to_json, "Bearer "+ "123")
end

When(/^A request to update a template props is received$/) do
  prop1 = FactoryGirl.build(:prop, name: Faker::Name.name, required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: Faker::Name.name, required: true, type:'NUMBER')
  @template.props = [prop1, prop2]
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
end

When(/^A request to update a template id is received$/) do
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_id_to_json, "Bearer "+ "123")
end

When(/^A request to update a template href is received$/) do
  @template.href = @service_client.get_base_uri + "/inventory/template/id/" + @template.id
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_href_to_json, "Bearer "+ "123")
end

When(/^A request to update a template createdOn is received$/) do
  @template.createdOn = DateTime.now.strftime "%Y-%m-%dT%H:%M:%SZ"
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_createdon_to_json, "Bearer "+ "123")
end

When(/^A request to update a template companyId is received$/) do
  @template.companyId = SecureRandom.uuid
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_companyid_to_json, "Bearer "+ "123")
end

Then(/^I should see the template was updated$/) do
  result = @service_client.get_by_url_with_auth(@service_client.get_base_uri + "/inventory/template/id/" + @template.id, 'Bearer 123')

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

Then(/^I should see the template name was updated$/) do
  result = @service_client.get_by_url_with_auth(@service_client.get_base_uri + "/inventory/template/id/" + @template.id, 'Bearer 123')
  expect(result["name"]).to eql @template.name
end

Then(/^I should see the template props were updated$/) do
  result = @service_client.get_by_url_with_auth(@service_client.get_base_uri + "/inventory/template/id/" + @template.id, 'Bearer 123')

  result["props"].each do |property|
    prop = @template.props.detect{|u| u.name == property['name']}
    expect(prop.name).to eql prop.name
    expect(prop.required).to eql prop.required
    expect(prop.type).to eql prop.type
  end
end