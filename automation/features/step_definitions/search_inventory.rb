Given(/^A ADMIN user exists and inventory exists for a company with different prop names$/) do
  @companyId = SecureRandom.uuid
  JWTSubject.new().generate_and_create_jwt_subject({role: 'ADMIN', companyId: @companyId})
  @template1 = Template.new().generate_and_create_random_prop_names({companyId: @companyId})
  sleep(0.1)

  @inventory = []
  inventory = Inventory.new().generate_and_create_inventory({template: @template1, companyId: @companyId,
                                                               createProps: true, name: Faker::Name.name});
  @inventory << inventory
  sleep(0.1)

  @template2 = Template.new().generate_and_create_random_prop_names({companyId: @companyId})
  sleep(0.1)

  inventory = Inventory.new().generate_and_create_inventory({template: @template2, companyId: @companyId,
                                                               createProps: true, name: Faker::Name.name});
  @inventory << inventory


  sleep(0.1)
  JWTSubject.new().generate_and_create_jwt_subject({role: 'ADMIN', companyId: @companyId})
end

When(/^A request to search for inventory is received$/) do
  inventory = FactoryGirl.build(:inventory, name: @inventory[0].name)
  @result = @service_client.post_to_url_with_auth("/inventory/search", inventory.search_by_name_to_json, "Bearer "+ "123")
  @inventory = [@inventory[0]]
end

When(/^A request to search for inventory is received with invalid search parameter (.*?)$/) do |field|
  inventory = FactoryGirl.build(:inventory, name: @inventory[0].name)
  body = inventory.search_by_name_to_hash
  body[field] = "test"
  @result = @service_client.post_to_url_with_auth("/inventory/search", body.to_json, "Bearer "+ "123")
end

When(/^A request to search for inventory is received with invalid prop search parameter (.*?)$/) do |field|
  prop = {}
  prop[field.to_sym] = "Test"
  body = {props: [prop]}
  @result = @service_client.post_to_url_with_auth("/inventory/search", body.to_json, "Bearer "+ "123")
end

When(/^A request to search for inventory is received with search parameter (.*?)$/) do |field|
  inventory = {}
  inventory[field.to_sym]=@inventory[0].create_hash[field.to_sym]
  @result = @service_client.post_to_url_with_auth("/inventory/search", inventory.to_json, "Bearer "+ "123")

  inventoryResultList = []

 @inventory.each do |inv|
    invHash = inv.create_hash

    if(invHash[field.to_sym] == inventory[field.to_sym])
      inventoryResultList << inv
    end
  end

  @inventory = []
  inventoryResultList.each do |inv|
    @inventory << inv
  end
end

When(/^A request to search for inventory is received with prop search parameter name$/) do
  prop = {}
  prop[:name] = @inventory[0].props[0].name
  body = {props: [prop]}
  @result = @service_client.post_to_url_with_auth("/inventory/search", body.to_json, "Bearer "+ "123")
  @inventory = [@inventory[0]]
end

When(/^A request to search an inventory is received$/) do
  inventory = FactoryGirl.build(:inventory, name: Faker::Name.name)
  @result = @service_client.post_to_url_with_auth("/inventory/search", inventory.search_by_name_to_json, "Bearer "+ "123")
end