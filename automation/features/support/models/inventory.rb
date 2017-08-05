class Inventory
  attr_accessor  :id, :href, :createdOn, :type, :props,
                 :companyId, :price, :quantity, :name, :description

  def generate_and_create_inventory(args={})
    default_values(args)

    if(args[:createProps])
      args[:template].props.each do |property|
        prop = FactoryGirl.build(:prop, name: property.name, required: property.required, type: property.type, value: "1234")
        @props << prop
      end
    end

    service_client = ServiceClient.new()
    result = service_client.post_to_url_with_auth("/inventory", create_to_json, "Bearer "+ "123")
    @href = result.headers['location']
    @id = @href.split("/id/").last
    self
  end

  def default_values(args={})
    @props = []
    @type = args[:template].name || "type"
    @price = args[:price] || 20.50
    @quantity = args[:quantity] || 100
    @name = args[:name] || "name"
    @description = args[:description] ||"description"
  end

  def create_to_json
    {
        type: self.type,
        price: self.price,
        quantity: self.quantity,
        name: self.name,
        description: self.description,
        props: props.map do |prop|
          prop.inventory_create_hash
        end
    }.to_json
  end

  def create_hash
    {
        type: self.type,
        price: self.price,
        quantity: self.quantity,
        name: self.name,
        description: self.description,
        props: props.map do |prop|
          prop.inventory_create_hash
        end
    }
  end

  def update_to_json
    {
        price: self.price,
        quantity: self.quantity,
        name: self.name,
        description: self.description,
        props: props.map do |prop|
          prop.inventory_create_hash
        end
    }.to_json
  end

  def update_hash
    {
        price: self.price,
        quantity: self.quantity,
        name: self.name,
        description: self.description,
        props: props.map do |prop|
          prop.inventory_create_hash
        end
    }
  end

  def search_by_name_to_json
    {
        name: self.name
    }.to_json
  end

  def search_by_name_to_hash
    {
        name: self.name
    }
  end

end