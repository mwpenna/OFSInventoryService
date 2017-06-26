Before('@service') do
  @service_client = ServiceClient.new
  @service_client.get_by_url(@service_client.get_mock_base_uri + '/users/clear')
end