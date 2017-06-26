@service
Feature: Template is created when template endpoint is called

  Scenario: A request to create a template is received by a SYSTEM_ADMIN
    Given A SYSTEM_ADMIN user exists for a company
    When A request to create a template is received
    Then the response should have a status of 201
    And I should see the location header populated