@service
Feature: Inventory is deleted when inventory endpoint is called

  Scenario: Try to delete a inventory that exists by ADMIN user
    Given A ADMIN user exists and inventory item exists for a company
    When A request is made to delete the inventory
    Then the response should have a status of 204
    And I should see the inventory does not exists

  Scenario: An ADMIN tries to delete and inventory item for a different company
    Given A ADMIN user exists and inventory item exists for a different company
    When A request is made to delete the inventory
    Then the response should have a status of 400
    And I should see the inventory does not exists

  Scenario: Try to delete a inventory that exists by SYSTEM_ADMIN user
    Given A SYSTEM_ADMIN user exists and inventory item exists for a company
    When A request is made to delete the inventory
    Then the response should have a status of 204
    And I should see the inventory does not exists

  Scenario: Try to delete a inventory that exists by ACCOUNT_MANAGER user
    Given A ACCOUNT_MANAGER user exists and inventory item exists for a company
    When A request is made to delete the inventory
    Then the response should have a status of 204
    And I should see the inventory does not exists

  Scenario: An ACCOUNT_MANAGER tries to delete and inventory item for a different company
    Given A ACCOUNT_MANAGER user exists and inventory item exists for a different company
    When A request is made to delete the inventory
    Then the response should have a status of 400

  Scenario: Try to delete a inventory that exists by CUSTOMER user
    Given A CUSTOMER user exists and inventory item exists for a company
    When A request is made to delete the inventory
    Then the response should have a status of 400

  Scenario: An CUSTOMER tries to delete and inventory item for a different company
    Given A CUSTOMER user exists and inventory item exists for a different company
    When A request is made to delete the inventory
    Then the response should have a status of 400

  Scenario: Try to delete a inventory that exists by WAREHOUSE user
    Given A WAREHOUSE user exists and inventory item exists for a company
    When A request is made to delete the inventory
    Then the response should have a status of 400

  Scenario: An WAREHOUSE tries to delete and inventory item for a different company
    Given A WAREHOUSE user exists and inventory item exists for a different company
    When A request is made to delete the inventory
    Then the response should have a status of 400

  Scenario: Try to delete a inventory that does not exists
    When A request is made to delete a inventory the does not exists
    Then the response should have a status of 404

  Scenario: A request to delete a inventory is received by a ADMIN
    Given User authenticate service returns an exception
    When A request is made to delete the inventory
    Then the response should have a status of 403

  Scenario: A request to delete a inventory is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request is made to delete the inventory
    Then the response should have a status of 403