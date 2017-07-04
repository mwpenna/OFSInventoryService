When(/^A request to create an inventory item is received$/) do
  binding.pry
  inventory = FactoryGirl.build(:inventory, companyId: @companyId)
  pending # Write code here that turns the phrase above into concrete actions
end