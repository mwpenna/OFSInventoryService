Given(/^A (.*?) user exists and inventory item exists with all prop type for a company$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: 'ADMIN', companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)

  prop1 = FactoryGirl.build(:prop, name: 'color', required: false, type:'STRING')
  prop2 = FactoryGirl.build(:prop, name: 'size', required: false, type:'NUMBER')
  prop3 = FactoryGirl.build(:prop, name: 'isInStock', required: false, type:'BOOLEAN')
  @template = FactoryGirl.build(:template, name: Faker::Name.name , props: [prop1, prop2, prop3])
  result = @service_client.post_to_url_with_auth("/inventory/template", @template.create_to_json, "Bearer "+ "123")
  location = result.headers['location']
  @template.companyId = @companyId
  @template.id = location.split("/id/").last

  inventoryprop1 = FactoryGirl.build(:prop, name: 'color', required: false, type:'STRING', value: "STRINGVALUE")
  inventoryprop2 = FactoryGirl.build(:prop, name: 'size', required: false, type:'NUMBER', value: "123")
  inventoryprop3 = FactoryGirl.build(:prop, name: 'isInStock', required: false, type:'BOOLEAN', value: "true")
  props = [inventoryprop1,inventoryprop2,inventoryprop3]

  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props, type: @template.name)
  sleep(0.1)
  result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
  @location = result.headers['location']
  @inventoryId = @location.split("/id/").last

  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: 'http://localhost:8080/company/id/'+ @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)
end

Given(/^A (.*?) user exists for a company and inventory item exists with type default$/) do |role|
  @companyId = SecureRandom.uuid
  jwtsubject = FactoryGirl.build(:jwtsubject, role: role, companyHref: "http://localhost:8080/company/id/" + @companyId)
  request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
  @service_client.post_to_url(@service_client.get_mock_base_uri + '/users/authenticate/status', request)

  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, type: 'DEFAULT')
  @result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
  @location = @result.headers['location']
  @inventoryId = @location.split("/id/").last
end

When(/^A request to update inventory is received$/) do
  @inventory.price = (rand 100.00...400.00).round(2)
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update an inventorys description is received$/) do
  @inventory.description = "test"
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update an inventorys name is received$/) do
  @inventory.name = "test"
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update an inventorys price is received$/) do
  @inventory.price = (rand 100.00...400.00).round(2)
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update an inventorys quantity is received$/) do
  @inventory.quantity = (rand 0...400)
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update an inventorys props is received$/) do
  @inventory.props.each do |property|
    property.value = "5678"
  end
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update an inventorys props field (.*?) is received$/) do |field|
  body = @inventory.update_hash
  body[:props].each do |prop|
    prop[field.to_sym]='test'
  end
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, body.to_json, "Bearer "+ "123")
end

When(/^A request to update invalid inventory field (.*?) is received$/) do |field|
  body = @inventory.update_hash
  body[field.to_sym]="test"
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, body.to_json, "Bearer "+ "123")
end

When(/^A request to update inventory that does not exists$/) do
  JWTSubject.new().generate_and_create_jwt_subject({role: 'ADMIN', companyId: SecureRandom.uuid})
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, type: Faker::Name.name)
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+SecureRandom.uuid, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory name to a name that already exists$/) do
  @inventory[1].name = @inventory[0].name
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventory[1].id, @inventory[1].update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory with duplicate props$/) do
  @inventory.props.each do |prop|
    @inventory.props << prop
    break
  end

  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory with missing required props$/) do
  @inventory.props = []
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update an inventory is received$/) do
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, type: Faker::Name.name)
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+SecureRandom.uuid, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory with prop that is not in the template is received$/) do
  prop = FactoryGirl.build(:prop, name: Faker::Name.name, value: "1234")
  @inventory.props <<  prop
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory item with invalid prop (.*?) value is received$/) do |type|
  @inventory.props.detect{|u| u.type == type}.value = "INVALIDVALUE"
  @invalidProp = @inventory.props.detect{|u| u.type == type}
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory item with valid prop NUMBER value is received$/) do
  @inventory.props.detect{|u| u.type == 'NUMBER'}.value = "555555"
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory item with valid prop BOOLEAN value is received$/) do
  @inventory.props.detect{|u| u.type == 'BOOLEAN'}.value = "false"
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory item with valid prop STRING value is received$/) do
  @inventory.props.detect{|u| u.type == 'STRING'}.value = "UPDATEDSTRINGVALUE"
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory item of type DEFAULT is received$/) do
  @inventory.price = 10000.round(2)
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

When(/^A request to update inventory item of type DEFAULT is received with PROPS$/) do
  prop = FactoryGirl.build(:prop, name: Faker::Name.name, value: "1234")
  @inventory.props = [prop]
  @result = @service_client.post_to_url_with_auth("/inventory/id/"+@inventoryId, @inventory.update_to_json, "Bearer "+ "123")
end

Then(/^I should see the updated inventory item was returned$/) do
  @result = @service_client.get_by_url_with_auth(@location, 'Bearer 123')

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

And(/^I should see an inventory error message indicating name exists$/) do
  expect(@result["errors"][0]).to eql Errors.inventory_name_exists
end

Then(/^I should see an error message indicating duplicate props$/) do
  expect(@result["errors"][0]).to eql Errors.prop_duplicate_name
end

Then(/^I should see an inventory error message indicating invalid prop$/) do
  expect(@result["errors"][0]).to eql Errors.inventory_invalid_prop
end