class Prop

  attr_accessor :name, :type, :required, :value, :defaultValue

  def create_to_json
    create_hash.to_json
  end

  def create_hash
    {
        name: self.name,
        type: self.type,
        required: self.required
    }.delete_if { |key, value| value.to_s.strip.empty? }
  end

  def inventory_create_hash
    {
        name: self.name,
        value: self.value
    }
  end

  def to_hash
    {
        name: self.name,
        type: self.type,
        required: self.required,
        value: self.value,
        defaultValue: self.defaultValue
    }.delete_if { |key, value| value.to_s.strip.empty? }
  end

  def update_hash
    {
        name: self.name,
        type: self.type,
        required: self.required,
        defaultValue: self.defaultValue
    }.delete_if { |key, value| value.to_s.strip.empty? }
  end

end