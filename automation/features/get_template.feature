@service
Feature: Template is retrieved when get template endpoint is called by user with valid credentials

  Scenario: A request to get a template is received by a SYSTEM_ADMIN
    Given A SYSTEM_ADMIN user and template exists for a company
    When A request to get the template is received
    Then the response should have a status of 200
    And I should see the template was returned

  Scenario: A request to get a template is received by a ADMIN
    Given A ADMIN user and template exists for a company
    When A request to get the template is received
    Then the response should have a status of 200
    And I should see the template was returned

  Scenario: A request to get a template is received by a ADMIN
    Given A ADMIN user and template exists for a different company
    When A request to get the template is received
    Then the response should have a status of 400

  Scenario: A request to get a template is received by a ACCOUNT_MANAGER
    Given A ADMIN user and template exists for a company
    When A request to get the template is received
    Then the response should have a status of 200
    And I should see the template was returned

  Scenario: A request to get a template is received by a ACCOUNT_MANAGER
    Given A ADMIN user and template exists for a different company
    When A request to get the template is received
    Then the response should have a status of 400

  Scenario: A request to get a template is received by a CUSTOMER
    Given A CUSTOMER user and template exists for a company
    When A request to get the template is received
    Then the response should have a status of 400

  Scenario: A request to get a template is received by a WAREHOUSE
    Given A WAREHOUSE user and template exists for a company
    When A request to get the template is received
    Then the response should have a status of 400

  Scenario: A request to get a template is received for a template that does not exists
    When A request to get a template that does not exists is received
    Then the response should have a status of 404

  Scenario: A request to get a template is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to get a template is received
    Then the response should have a status of 403

  Scenario: A request to get a template is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to get a template is received
    Then the response should have a status of 403