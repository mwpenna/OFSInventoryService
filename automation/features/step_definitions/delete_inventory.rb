When(/^A request is made to delete the inventory$/) do
  inventoryId = @inventoryId || SecureRandom.uuid
  @result = @service_client.delete_by_url_with_auth(@service_client.get_base_uri + '/inventory/id/' + inventoryId, 'Bearer 123')
end

And(/^I should see the inventory does not exists$/) do
  result = @service_client.delete_by_url_with_auth(@service_client.get_base_uri + '/inventory/id/' + @inventoryId, 'Bearer 123')
  expect(result.response.code.to_i).to eql 404
end

When(/^A request is made to delete a inventory the does not exists$/) do
  @result = @service_client.delete_by_url_with_auth(@service_client.get_base_uri + '/inventory/id/' + SecureRandom.uuid, 'Bearer 123')

end
