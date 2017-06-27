class Template

  attr_accessor :name, :companyId, :props

  def create_to_json
    {
        name: self.name,
        companyId: self.companyId,
        props: props.map do |prop|
          prop.create_hash
        end
    }.to_json
  end

  def create_to_hash
    {
        name: self.name,
        companyId: self.companyId,
        props: props.map do |prop|
          prop.create_hash
        end
    }
  end

end