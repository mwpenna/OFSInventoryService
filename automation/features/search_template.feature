@service
Feature: Template list is returned when search by enpoint is called

  Scenario: a request to search for template is received by user with ACCOUNT_MANAGER role
    Given A ACCOUNT_MANAGER user exists and templates exists for a company
    When A request to search for a template is received
    Then the response should have a status of 200
    And I should see the template list was returned

  Scenario: a request to search for template is received by user with ADMIN role
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received
    Then the response should have a status of 200
    And I should see the template list was returned

  Scenario: Bad Request is returned when a request to search for template is received by user with WAREHOUSE role
    Given A WAREHOUSE user exists and templates exists for a company
    When A request to search for a template is received
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search for template is received by user with CUSTOMER role
    Given A CUSTOMER user exists and templates exists for a company
    When A request to search for a template is received
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search  for template is received with a search parameter of id
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received with invalid search parameter id
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search  for template is received with a search parameter of href
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received with invalid search parameter href
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search  for template is received with a search parameter of createdOn
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received with invalid search parameter createdOn
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search  for template is received with a search parameter of companyId
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received with invalid search parameter companyId
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search  for template is received with a prop search parameter of type
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received with invalid prop search parameter type
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search  for template is received with a prop search parameter of required
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received with invalid prop search parameter required
    Then the response should have a status of 400

  Scenario: A request to search for templates is received by ADMIN user with search parameter of name
    Given A ADMIN user exists and templates exists for a company
    When A request to search for a template is received with search parameter name
    Then the response should have a status of 200
    And I should see the template list was returned

  Scenario: A request to search for templates is received by ADMIN user with a prop search parameter of name
    Given A ADMIN user exists and templates exists with different prop names for a company
    When A request to search for a template is received with prop search parameter name
    Then the response should have a status of 200
    And I should see the template list was returned

  Scenario: A request to search for templates is received by ADMIN user with a prop search parameter of name
    Given A ADMIN user exists and templates exists with different prop names for a company
    When A request to search for a template is received with both prop search parameter and name parameter
    Then the response should have a status of 200
    And I should see the template list was returned

  Scenario: A request to search for templates is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to search for templates is received
    Then the response should have a status of 403

  Scenario: A request to get search for templates is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to search for templates is received
    Then the response should have a status of 403