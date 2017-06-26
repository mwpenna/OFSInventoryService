class Prop

  attr_accessor :name, :type, :required

  def create_to_json
    create_hash.to_json
  end

  def create_hash
    {
        name: self.name,
        type: self.type,
        required: self.required
    }
  end

end