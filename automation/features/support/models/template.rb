class Template

  attr_accessor :name, :companyHref, :props

  def create_to_json
    {
        name: self.name,
        companyHref: self.companyHref,
        props: props.map do |prop|
          prop.create_hash
        end
    }.to_json
  end

end