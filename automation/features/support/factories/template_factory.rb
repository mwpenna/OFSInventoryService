require_relative '../env'

FactoryGirl.define do

  factory :template, class: Template do
    name "temp"
    companyId "123"
    props []
  end

end