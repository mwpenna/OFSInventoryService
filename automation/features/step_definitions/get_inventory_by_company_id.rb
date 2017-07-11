Given(/^A (.*?) user exists and inventory exists for a company$/) do |role|
  @companyId = SecureRandom.uuid
  JWTSubject.new().generate_and_create_jwt_subject({role: 'ADMIN', companyId: @companyId})
  @template = Template.new().generate_and_create_template({companyId: @companyId})
  sleep(0.1)
  
  @inventory = []
  rand(2..5).times do
    inventory = Inventory.new().generate_and_create_inventory({template: @template, companyId: @companyId,
                                                               createProps: true, name: Faker::Name.name});
    @inventory << inventory
  end
  sleep(0.1)
  JWTSubject.new().generate_and_create_jwt_subject({role: role, companyId: @companyId})
end

When(/^A request to get the inventory by company id is received$/) do
  @result = @service_client.get_by_url_with_auth(@service_client.get_base_uri + '/inventory/company/id/' + @companyId, "Bearer 123")
end

And(/^I should see the inventory list was returned$/) do
  expect(@result["count"]).to eql @inventory.size
  expect(@result["items"].size).to eql @inventory.size

  @result["items"].each do |response|
    inventory = @inventory.detect{|i| i.id == response['id']}

    expect(response["id"]).to eql inventory.id
    expect(response["href"]).to eql inventory.href
    expect(response["createdOn"]).to_not be_nil
    expect(response["type"]).to eql inventory.type
    expect(response["companyId"]).to eql @companyId
    expect(response["price"]).to eql inventory.price
    expect(response["quantity"]).to eql inventory.quantity
    expect(response["name"]).to eql inventory.name
    expect(response["description"]).to eql inventory.description
    expect(response["props"]).to_not be_nil

    response["props"].each do |property|
      prop = inventory.props.detect{|u| u.name == property['name']}
      expect(property["name"]).to eql prop.name
      expect(property["required"]).to eql prop.required
      expect(property["type"]).to eql prop.type
      expect(property["value"]).to eql prop.value
    end
  end
end