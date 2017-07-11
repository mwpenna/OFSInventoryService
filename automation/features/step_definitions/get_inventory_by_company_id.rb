Given(/^A (.*?) user exists and inventory exists for a company$/) do |role|
  @companyId = SecureRandom.uuid
  JWTSubject.new().generate_and_create_jwt_subject({role: 'ADMIN', companyId: @companyId})

  @template = Template.new().generate_and_create_template({companyId: @companyId})
  binding.pry

  props = []
  @template.props.each do |property|
    prop = FactoryGirl.build(:prop, name: property.name, required: property.required, type: property.type, value: "1234")
    props << prop
  end
  @inventory = FactoryGirl.build(:inventory, companyId: @companyId, props: props, type: @template.name)
  sleep(0.1)
  result = @service_client.post_to_url_with_auth("/inventory", @inventory.create_to_json, "Bearer "+ "123")
  @location = result.headers['location']

  JWTSubject.new().generate_and_create_jwt_subject({role: role, companyId: @companyId})
end