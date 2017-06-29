@service
Feature: Template list is retrieved when get template endpoint is called by user with valid credentials

  Scenario: A request to get templates by company id is received by a ADMIN
    Given A ADMIN user exists and templates exists for a company
    When A request to get the templates by company id is received
    Then the response should have a status of 200
    And I should see the template list was returned

  Scenario: A request to get templates by company id is received by a ACCOUNT_MANAGER
    Given A ACCOUNT_MANAGER user exists and templates exists for a company
    When A request to get the templates by company id is received
    Then the response should have a status of 200
    And I should see the template list was returned

  Scenario: A request to get templates by company id is received by a WAREHOUSE
    Given A WAREHOUSE user exists and templates exists for a company
    When A request to get the templates by company id is received
    Then the response should have a status of 400

  Scenario: A request to get templates by company id is received by a CUSTOMER
    Given A CUSTOMER user exists and templates exists for a company
    When A request to get the templates by company id is received
    Then the response should have a status of 400

  Scenario: A request to get templates by company id is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to get the templates by company id is received
    Then the response should have a status of 403

  Scenario: A request to get templates by company id is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to get the templates by company id is received
    Then the response should have a status of 403

  Scenario: Empty Template List is returned when a request to get template by company id is received
    Given A company exists without templates
    When A request to get the templates by company id is received
    Then the response should have a status of 200
    And I should see an empty list was returned

  Scenario: Empty Template list is returned when a company does not exists
    When A request to get the template for a company id that does not exists is received
    Then the response should have a status of 200
    And I should see an empty list was returned
