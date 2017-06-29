@service
Feature: Template is deleted when template endpoint is called

  Scenario: Try to delete a template that exists by ADMIN user
    Given A ADMIN user and template exists
    When A request is made to delete the template
    Then the response should have a status of 204
    And I should see the user does not exists

  Scenario: Try to delete a template that exists by SYSTEM_ADMIN user
    Given A SYSTEM_ADMIN user and template exists
    When A request is made to delete the template
    Then the response should have a status of 204
    And I should see the user does not exists

  Scenario: Try to delete a template that exists by ACCOUNT_MANAGER user
    Given A ACCOUNT_MANAGER user and template exists
    When A request is made to delete the template
    Then the response should have a status of 400

  Scenario: Try to delete a template that exists by CUSTOMER user
    Given A CUSTOMER user and template exists
    When A request is made to delete the template
    Then the response should have a status of 400

  Scenario: Try to delete a template that exists by WAREHOUSE user
    Given A WAREHOUSE user and template exists
    When A request is made to delete the template
    Then the response should have a status of 400

  Scenario: Try to delete a template that does not exists
    When A request is made to delete a template the does not exists
    Then the response should have a status of 404

  Scenario: A request to delete a templates is received by a ADMIN
    Given User authenticate service returns an exception
    When A request is made to delete the template
    Then the response should have a status of 403

  Scenario: A request to delete a templates is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request is made to delete the template
    Then the response should have a status of 403