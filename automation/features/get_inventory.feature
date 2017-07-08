@service
Feature: Inventory is retrieved when get inventory endpoint is called by user with valid credentials

  Scenario: A request to get an inventory item is received by a SYSTEM_ADMIN
    Given A SYSTEM_ADMIN user exists and inventory item exists for a company
    When A request to get the inventory item is received
    Then the response should have a status of 200
    And I should see the inventory item was returned

  Scenario: A request to get an inventory item is received by a ADMIN
    Given A ADMIN user exists and inventory item exists for a company
    When A request to get the inventory item is received
    Then the response should have a status of 200
    And I should see the inventory item was returned

  Scenario: A request to get an inventory item is received by a ADMIN
    Given A ADMIN user exists and inventory item exists for a different company
    When A request to get the inventory item is received
    Then the response should have a status of 400

  Scenario: A request to get an inventory item is received by a ACCOUNT_MANAGER
    Given A ACCOUNT_MANAGER user exists and inventory item exists for a company
    When A request to get the inventory item is received
    Then the response should have a status of 200
    And I should see the inventory item was returned

  Scenario: A request to get a inventory item is received by a ACCOUNT_MANAGER
    Given A ACCOUNT_MANAGER user exists and inventory item exists for a different company
    When A request to get the inventory item is received
    Then the response should have a status of 400

  Scenario: A request to get a inventory item is received by a CUSTOMER
    Given A CUSTOMER user exists and inventory item exists for a company
    When A request to get the inventory item is received
    Then the response should have a status of 400

  Scenario: A request to get a inventory item is received by a WAREHOUSE
    Given A WAREHOUSE user exists and inventory item exists for a company
    When A request to get the inventory item is received
    Then the response should have a status of 400

  Scenario: A request to get a inventory item is received for a inventory item that does not exists
    When A request to get an inventory item that does not exists is received
    Then the response should have a status of 404

  Scenario: A request to get a inventory item is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to get an inventory item is received
    Then the response should have a status of 403

  Scenario: A request to get a inventory item is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to get an inventory item is received
    Then the response should have a status of 403