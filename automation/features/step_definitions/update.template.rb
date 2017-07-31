Given(/^A ADMIN user exists and template does not exists$/) do
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: "http://localhost:8080/company/id/" + @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^A company exists with an ADMIN user, template, and inventory not for that template$/) do
  @companyId = SecureRandom.uuid
  JWTSubject.new().generate_and_create_jwt_subject({role: 'ADMIN', companyId: @companyId})
  @template = Template.new().generate_and_create_template({companyId: @companyId})
  sleep(0.1)

  @inventory = Inventory.new().generate_and_create_inventory({template: @template, companyId: @companyId,
                                                              createProps: true, name: Faker::Name.name});
  sleep(0.1)
  prop1 = FactoryGirl.build(:prop, name: 'stringValue', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'numberValue', required: true, type:'NUMBER')
  props = [prop1, prop2]
  @template = Template.new().generate_and_create_template({companyId: @companyId, props: props})
  sleep(0.1)
  JWTSubject.new().generate_and_create_jwt_subject({role: 'ADMIN', companyId: @companyId})
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
  prop1 = FactoryGirl.build(:prop, name: Faker::Name.name, required: false, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: Faker::Name.name, required: false, type:'NUMBER')
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

When(/^A request to update a template with duplicate props$/) do
  prop1 = FactoryGirl.build(:prop, name: 'color', required: false, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: Faker::Name.name, required: false, type:'NUMBER')
  prop3 = FactoryGirl.build(:prop, name: 'color', required: false, type:'STRING')
  @template.props = [prop1, prop2, prop3]
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
end

When(/^A request is made to update a template props with new required field and defaultValue is missing$/) do
  @newProp = FactoryGirl.build(:prop, name: Faker::Name.name, required: true, type:'STRING')
  @template.props << @newProp
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
end

When(/^A request is made to update a template props with no required field and defaultValue is missing$/) do
  @newProp = FactoryGirl.build(:prop, name: Faker::Name.name, required: false, type:'STRING')
  @template.props << @newProp
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
end

When(/^A request is made to update a template props with invalid (.*?) defaultValue$/) do |type|
  @newProp = FactoryGirl.build(:prop, name: Faker::Name.name, required: true, type: type, defaultValue: "INVALIDNUMBER")
  @template.props << @newProp
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
end

When(/^A request is made to update a template props with valid defaultValue type$/) do
  @newProp = FactoryGirl.build(:prop, name: Faker::Name.name, required: true, type: 'STRING', defaultValue: "VALIDDEFAULTVALUE")
  @template.props << @newProp
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
end

When(/^A request is made to update a template with no new props$/) do
  @template.name = Faker::Name.name
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_name_to_json, "Bearer "+ "123")
end

When(/^A request is made to update a template props$/) do
  @newProp = FactoryGirl.build(:prop, name: Faker::Name.name, required: true, type: 'STRING', defaultValue: "VALIDDEFAULTVALUE")
  @template.props << @newProp
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
end

When(/^A request is made to update a templates props$/) do
  @newProp = FactoryGirl.build(:prop, name: Faker::Name.name, required: true, type: 'STRING', defaultValue: "VALIDDEFAULTVALUE")
  @template.props << @newProp
  @result = @service_client.post_to_url_with_auth("/inventory/template/id/"+@template.id, @template.update_props_to_json, "Bearer "+ "123")
  sleep(0.2)
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

And(/^I should see an error message indicating default value missing$/) do
  expect(@result["errors"][0]).to eql Errors.props_missing_default_value(@newProp.name)
end

And(/^I should see an error message indicating invalid prop value$/) do
  expect(@result["errors"][0]).to eql Errors.prop_invalid_value(@newProp.defaultValue, @newProp.type, @newProp.name)
end

And(/^I should see inventory for that template was updated with new props$/) do
  @result = @service_client.get_by_url_with_auth(@location, 'Bearer 123')

  @inventory.props.each do |property|
    prop = @result["props"].detect{|u| u["name"] == property.name}
    expect(prop["name"]).to eql property.name
    expect(prop["required"]).to eql property.required
    expect(prop["type"]).to eql property.type
    expect(prop["value"]).to eql property.value
    expect(prop["defaultValue"]).to eql nil
  end

  prop = @result["props"].detect{|u| u["name"] == @newProp.name}
  expect(prop["name"]).to eql @newProp.name
  expect(prop["required"]).to eql @newProp.required
  expect(prop["type"]).to eql @newProp.type
  expect(prop["value"]).to eql @newProp.defaultValue
  expect(prop["defaultValue"]).to eql nil
end

And(/^I should see inventory was not updated with new props$/) do
  @result = @service_client.get_by_url_with_auth(@inventory.href, 'Bearer 123')

  @inventory.props.each do |property|
    prop = @result["props"].detect{|u| u["name"] == property.name}
    expect(prop["name"]).to eql property.name
    expect(prop["required"]).to eql property.required
    expect(prop["type"]).to eql property.type
    expect(prop["value"]).to eql property.value
    expect(prop["defaultValue"]).to eql nil
  end

  prop = @result["props"].detect{|u| u["name"] == @newProp.name}
  expect(prop).to eql nil
end