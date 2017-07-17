require 'factory_girl'
require 'faker'

class Template

  attr_accessor :name, :companyId, :props, :id, :href, :createdOn, :location

  def generate_and_create_template(args={})
    prop1 = FactoryGirl.build(:prop, name: 'color', required: true, type:'STRING')
    prop2 = FactoryGirl.build(:prop, name: 'size', required: true, type:'NUMBER')
    @props = [prop1, prop2]
    @name = Faker::Name.name

    service_client = ServiceClient.new
    result = service_client.post_to_url_with_auth("/inventory/template", create_to_json, "Bearer "+ "123")

    @location = result.headers['location']
    @companyId = args[:companyId]
    @id = location.split("/id/").last
    self
  end

  def create_to_json
    {
        name: self.name,
        props: props.map do |prop|
          prop.create_hash
        end
    }.to_json
  end

  def create_to_hash
    {
        name: self.name,
        props: props.map do |prop|
          prop.create_hash
        end
    }
  end

  def create_to_json_with_company_id
    {
        name: self.name,
        companyId: self.companyId,
        props: props.map do |prop|
          prop.create_hash
        end
    }.to_json
  end

  def create_to_hash_with_company_id
    {
        name: self.name,
        companyId: self.companyId,
        props: props.map do |prop|
          prop.create_hash
        end
    }
  end

  def update_name_to_json
    {
        name: self.name
    }.to_json
  end

  def update_props_to_json
    {
        props: props.map do |prop|
          prop.update_hash
        end
    }.to_json
  end

  def update_id_to_json
    {
        id: self.id
    }.to_json
  end

  def update_href_to_json
    {
        href: self.href
    }.to_json
  end

  def update_createdon_to_json
    {
        createdOn: self.createdOn
    }.to_json
  end

  def update_companyid_to_json
    {
        companyId: self.companyId
    }.to_json
  end

end