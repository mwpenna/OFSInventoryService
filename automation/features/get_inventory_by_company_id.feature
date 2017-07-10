@service
Feature: Inventory list is retrieved when get Inventory endpoint is called by user with valid credentials

  Scenario: A request to get Inventory by company id is received by a SYSTEM_ADMIN
    Given A SYSTEM_ADMIN user exists and inventory exists for a company
    When A request to get the inventory by company id is received
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: A request to get Inventory by company id is received by a ADMIN
    Given A ADMIN user exists and inventory exists for a company
    When A request to get the inventory by company id is received
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: An ADMIN makes a request to get inventory for a different company
    Given A ADMIN user exists and inventory exists for a different company
    When A request to get the inventory by company id is received
    Then the response should have a status of 400

  Scenario: A request to get inventory by company id is received by a ACCOUNT_MANAGER
    Given A ACCOUNT_MANAGER user exists and inventory exists for a company
    When A request to get the inventory by company id is received
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: An ACCOUNT_MANAGER makes a request to get inventory for a different company
    Given A ACCOUNT_MANAGER user exists and inventory exists for a different company
    When A request to get the inventory by company id is received
    Then the response should have a status of 400

  Scenario: A request to get inventory by company id is received by a WAREHOUSE
    Given A WAREHOUSE user exists and inventory exists for a company
    When A request to get the inventory by company id is received
    Then the response should have a status of 400

  Scenario: An WAREHOUSE makes a request to get inventory for a different company
    Given A WAREHOUSE user exists and inventory exists for a different company
    When A request to get the inventory by company id is received
    Then the response should have a status of 400

  Scenario: A request to get inventory by company id is received by a CUSTOMER
    Given A CUSTOMER user exists and inventory exists for a company
    When A request to get the inventory by company id is received
    Then the response should have a status of 400

  Scenario: An CUSTOMER makes a request to get inventory for a different company
    Given A CUSTOMER user exists and inventory exists for a different company
    When A request to get the inventory by company id is received
    Then the response should have a status of 400

  Scenario: A request to get inventory by company id is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to get the inventory by company id is received
    Then the response should have a status of 403

  Scenario: A request to get inventory by company id is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to get the inventory by company id is received
    Then the response should have a status of 403

  Scenario: Empty inventory List is returned when a request to get inventory by company id is received
    Given A company exists without inventory
    When A request to get the inventory by company id is received
    Then the response should have a status of 200
    And I should see an empty list was returned

  Scenario: Empty inventory list is returned when a company does not exists
    When A request to get the inventory for a company id that does not exists is received
    Then the response should have a status of 200
    And I should see an empty list was returned
