Given(/^A (.*?) user exists and inventory item exists for a company$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)

  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  result = @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json, "Bearer "+ "123")
  location = result.headers['location']
  @template.companyId = @companyId
  @template.id = location.split("/id/").last

  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, required: property.required, type: property.type, value: "1234")
    props << prop
  end
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props, type: @template.name)
  sleep(0.1)
  result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
  @location = result.headers['location']

  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^A (.*?) user exists and inventory item exists for a different company$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)

  prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2])
  result = @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json, "Bearer "+ "123")
  location = result.headers['location']
  @template.companyId = @companyId
  @template.id = location.split("/id/").last

  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, required: property.required, type: property.type, value: "1234")
    props << prop
  end
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props, type: @template.name)
  sleep(0.1)
  result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
  @location = result.headers['location']

  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

When(/^A request to get the inventory item is received$/) do
  @result = @service_client.get_by_url_with_auth(@location, 'Bearer 123')
end

When(/^A request to get an inventory item that does not exists is received$/) do
  @result = @service_client.get_by_url_with_auth("http://localhost:8083/inventory/id/123", 'Bearer 123')
end

When(/^A request to get an inventory item is received$/) do
  @result = @service_client.get_by_url_with_auth("http://localhost:8083/inventory/id/123", 'Bearer 123')
end

And(/^I should see the inventory item was returned$/) do
  expect(@result["id"]).to_not be_nil
  expect(@result["href"]).to_not be_nil
  expect(@result["createdOn"]).to_not be_nil
  expect(@result["type"]).to eql @inventory.type
  expect(@result["companyId"]).to eql @inventory.companyId
  expect(@result["price"]).to eql @inventory.price
  expect(@result["quantity"]).to eql @inventory.quantity
  expect(@result["name"]).to eql @inventory.name
  expect(@result["description"]).to eql @inventory.description
  expect(@result["props"]).to_not be_nil

  @result["props"].each do |property|
    prop = @inventory.props.detect{|u| u.name == property['name']}
    expect(property["name"]).to eql prop.name
    expect(property["required"]).to eql prop.required
    expect(property["type"]).to eql prop.type
    expect(property["value"]).to eql prop.value
  end
end