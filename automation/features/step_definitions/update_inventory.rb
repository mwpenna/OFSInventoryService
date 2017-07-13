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

And(/^I should see an inventory error message indicating name does not exists$/) do
  expect(@result["errors"][0]).to eql Errors.inventory_name_exists
end

Then(/^I should see an inventory error message indicating duplicate props$/) do
  expect(@result["errors"][0]).to eql Errors.inventory_prop_duplicate_name
end