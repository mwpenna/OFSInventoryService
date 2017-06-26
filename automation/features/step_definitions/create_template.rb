Given(/^A SYSTEM_ADMIN user exists for a company$/) do
  binding.pry
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^A request to create a template is received$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the response should have a status of (\d+)$/) do |response_code|
  expect(@result.response.code.to_i).to eql response_code.to_i
end

And(/^I should see the location header populated$/) do
  expect(@result.headers['location']).to_not be_nil
end
