@service
Feature: Inventory is update when inventory endpoint is called

  Scenario: A request to update inventory by id is received by ADMIN user
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update inventory is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update inventory by id is received by SYSTEM_ADMIN user
    Given A SYSTEM_ADMIN user exists and inventory item exists for a company
    When A request to update inventory is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update inventory by id is received by ACCOUNT_MANAGER user
    Given A ACCOUNT_MANAGER user exists and inventory item exists for a company
    When A request to update inventory is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update inventory by id is received by WAREHOUSE user
    Given A WAREHOUSE user exists and inventory item exists for a company
    When A request to update inventory is received
    Then the response should have a status of 400

  Scenario: A request to update inventory by id is received by CUSTOMER user
    Given A CUSTOMER user exists and inventory item exists for a company
    When A request to update inventory is received
    Then the response should have a status of 400

  Scenario: A request to update inventory by id for a different company is received by ADMIN user
    Given A ADMIN user exists and inventory item exists for a different company
    When A request to update inventory is received
    Then the response should have a status of 400

  Scenario: A request to update inventory by id for a different company is received by ACCOUNT_MANAGER user
    Given A ACCOUNT_MANAGER user exists and inventory item exists for a different company
    When A request to update inventory is received
    Then the response should have a status of 400

  Scenario: A request to update inventory by id for a different company is received by WAREHOUSE user
    Given A WAREHOUSE user exists and inventory item exists for a different company
    When A request to update inventory is received
    Then the response should have a status of 400

  Scenario: A request to update inventory by id for a different company is received by CUSTOMER user
    Given A CUSTOMER user exists and inventory item exists for a different company
    When A request to update inventory is received
    Then the response should have a status of 400

  Scenario: A request to update inventory field description is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update an inventorys description is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update inventory field Name is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update an inventorys name is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update inventory field price is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update an inventorys price is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update inventory field quantity is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update an inventorys quantity is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update inventory field props is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update an inventorys props is received
    Then the response should have a status of 204
    And I should see the updated inventory item was returned

  Scenario: A request to update invalid inventory field href is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update invalid inventory field href is received
    Then the response should have a status of 400
    And I should see an inventory error message with href not allowed

  Scenario: A request to update invalid inventory field createdOn is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update invalid inventory field createdOn is received
    Then the response should have a status of 400
    And I should see an inventory error message with createdOn not allowed

  Scenario: A request to update invalid inventory field id is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update invalid inventory field id is received
    Then the response should have a status of 400
    And I should see an inventory error message with id not allowed

  Scenario: A request to update invalid inventory field companyId is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update invalid inventory field companyId is received
    Then the response should have a status of 400
    And I should see an inventory error message with companyId not allowed

  Scenario: A request to update invalid inventory field type is received
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update invalid inventory field type is received
    Then the response should have a status of 400
    And I should see an inventory error message with type not allowed

  Scenario: A request to update an inventory item that does not exists
    When A request to update inventory that does not exists
    Then the response should have a status of 404

  Scenario: A request to update an inventory field name to a name that already exists for company
    Given A ADMIN user exists and inventory exists for a company
    When A request to update inventory name to a name that already exists
    Then the response should have a status of 400
    And I should see an inventory error message indicating name does not exists

  Scenario: A request to update an inventory with duplicate props
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update inventory with duplicate props
    Then the response should have a status of 400
    And I should see an inventory error message indicating duplicate props

  Scenario: A request to update an inventory props with missing required props
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update inventory with missing required props
    Then the response should have a status of 400
    And I should see an inventory error message indicating required prop missing

  Scenario: A request to update inventory by id is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to update an inventory is received
    Then the response should have a status of 403

  Scenario: A request to update inventory by id is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to update an inventory is received
    Then the response should have a status of 403

  Scenario: A request to update inventory props with a prop that is not in the template is received by an admin
    Given A ADMIN user exists and inventory item exists for a company
    When A request to update inventory with prop that is not in the template is received
    Then the response should have a status of 400
    And I should see an inventory error message indicating invalid prop
