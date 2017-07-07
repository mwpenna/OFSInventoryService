class Inventory
  attr_accessor  :id, :href, :createdOn, :type, :props,
                 :companyId, :price, :quantity, :name, :description

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

end