When(/^A request to create an inventory item is received$/) do
  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, required: property.required, type: property.type, value: "1234")
    props << prop
  end
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props, type: @template.name)
  sleep(1)
  @result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
  sleep(1)
  @location = @result.headers['location']
end

When(/^A request to create an inventory item is received for a user that does not exists$/) do
  @inventory = FactoryGirl.build(:inventory)
  @result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
  @location = @result.headers['location']
end

When(/^A request to create an inventory item is received without (.*?)$/) do |field|
  @inventory = FactoryGirl.build(:inventory)
  body =  @inventory.create_hash
  body.delete(field.to_sym)
  @result = @service_client.post_to_url_with_auth("/inventory", body.to_json, "Bearer "+ "123")
end

When(/^A request to create an inventory item is received with missing prop (.*?)$/) do |field|
  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, value: "1234")
    props << prop
  end
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props, type: @template.name)
  body = @inventory.create_hash
  body[:props].each do |prop|
    prop.delete(field.to_sym)
  end
  @result = @service_client.post_to_url_with_auth("/inventory", body.to_json, "Bearer "+ "123")
end

When(/^A request to create an inventory item is received with invalid field (.*?)$/) do |field|
  @inventory = FactoryGirl.build(:inventory)
  body =  @inventory.create_hash
  body[field.to_sym] = "test"
  @result = @service_client.post_to_url_with_auth("/inventory", body.to_json, "Bearer "+ "123")
end

When(/^A request to create an inventory item is received with invalid prop (.*?)$/) do |field|
  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, value: "1234")
    props << prop
  end

  @inventory = FactoryGirl.build(:inventory, props: props)
  body =  @inventory.create_hash
  body[:props].each do |prop|
    prop[field.to_sym] = "test"
  end
  @result = @service_client.post_to_url_with_auth("/inventory", body.to_json, "Bearer "+ "123")
end

When(/^A request to create an inventory item is received with an invalid inventory type$/) do
  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, value: "1234")
    props << prop
  end
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props)
  @result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
end

When(/^A request to create an inventory item is received with missing props$/) do
  sleep(1)
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, type: @template.name)
  @result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
end

And(/^I should see an inventory error message with (.*?) not allowed/) do |property|
  expect(@result["errors"][0]).to eql Errors.inventory_field_not_acceptable(property)
end

And(/^I should see an inventory error message with (.*?) missing$/) do |property|
  expect(@result["errors"][0]).to eql Errors.inventory_required_field_missing(property)
end

And(/^I should see an inventory error message indicating prop (.*?) missing$/) do |property|
  expect(@result["errors"][0]).to eql Errors.inventory_props_required_field_missing(property)
end

And(/^I should see an inventory error message indicating required prop missing$/) do
  expect(@result["errors"][0]).to eql Errors.inventory_required_prop_missing
end

And(/^I should see an inventory error message indicating prop (.*?) invalid$/) do |property|
  expect(@result["errors"][0]).to eql Errors.inventory_prop_field_not_acceptable(property)
end

And(/^I should see an inventory error message indicating invalid inventory type$/) do
  expect(@result["errors"][0]).to eql Errors.inventory_type_not_valid
end

And(/^I should see the inventory item was created$/) do
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