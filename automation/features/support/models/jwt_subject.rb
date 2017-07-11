class JWTSubject
  attr_accessor  :href, :companyHref, :firstName, :lastName, :role, :userName, :emailAddress

  def generate_and_create_jwt_subject(args={})
    jwtsubject = FactoryGirl.build(:jwtsubject, role: args[:role], companyHref: 'http://localhost:8080/company/id/'+ args[:companyId])
    request = '{"status": 200, "message":'+ jwtsubject.to_json+'}'
    service_client = ServiceClient.new
    service_client.post_to_url(service_client.get_mock_base_uri + '/users/authenticate/status', request)
    jwtsubject
  end

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