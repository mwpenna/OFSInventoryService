require_relative '../env'

FactoryGirl.define do

  factory :jwtsubject, class: JWTSubject do
    href "http://localhost:8080/users/id/123"
    companyHref "http://localhost:8080/company/id/123"
    firstName "fname"
    lastName "lName"
    role "ADMIN"
    userName "userName"
    emailAddress "me@me.com"
  end

end