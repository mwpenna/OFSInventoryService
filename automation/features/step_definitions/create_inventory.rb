When(/^A request to create an inventory item is received$/) do
  sleep(1)
  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, value: "1234")
    props << prop
  end
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props, type: @template.name)
  @result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
end