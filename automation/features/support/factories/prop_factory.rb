require_relative '../env'

FactoryGirl.define do

  factory :prop, class: Prop do
    name "tmp"
    type "STRING"
    required false
  end

end