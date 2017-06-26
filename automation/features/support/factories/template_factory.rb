require_relative '../env'

FactoryGirl.define do

  factory :template, class: Template do
    name "temp"
    companyHref "http://localhost:8083/inventory/id/123"
    props []
  end

end