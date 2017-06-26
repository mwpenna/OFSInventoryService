class JWTSubject
  attr_accessor  :href, :companyHref, :firstName, :lastName, :role, :userName, :emailAddress

  def to_json
    {
        href: self.href,
        companyHref: self.companyHref,
        firstName: self.firstName,
        lastName: self.lastName,
        role: self.role,
        userName: self.userName,
        emailAddress: self.emailAddress
    }.to_json
  end

end