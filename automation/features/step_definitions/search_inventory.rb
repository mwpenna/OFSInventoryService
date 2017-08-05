When(/^A request to search for inventory is received$/) do
  inventory = FactoryGirl.build(:inventory, name: @inventory[0].name)
  @result = @service_client.post_to_url_with_auth("/inventory/search", inventory.search_by_name_to_json, "Bearer "+ "123")
  @inventory = [@inventory[0]]
end