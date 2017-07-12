@service
Feature: Inventory is update when inventory endpoint is called

  Scenario: A request to update inventory by id is received by ADMIN user
  Scenario: A request to update inventory by id is received by SYSTEM_ADMIN user
  Scenario: A request to update inventory by id is received by ACCOUNT_MANAGER user
  Scenario: A request to update inventory by id is received by WAREHOUSE user
  Scenario: A request to update inventory by id is received by CUSTOMER user

  Scenario: A request to update inventory by id for a different company is received by ADMIN user
  Scenario: A request to update inventory by id for a different company is received by ACCOUNT_MANAGER user
  Scenario: A request to update inventory by id for a different company is received by WAREHOUSE user
  Scenario: A request to update inventory by id for a different company is received by CUSTOMER user

  Scenario: A request to update inventory field description is received
  Scenario: A request to update inventory field Name is received
  Scenario: A request to update inventory field price is received
  Scenario: A request to update inventory field quantity is received
  Scenario: A request to update inventory field props is received

  Scenario: A request to update invalid inventory field href is received
  Scenario: A request to update invalid inventory field createdOn is received
  Scenario: A request to update invalid inventory field id is received
  Scenario: A request to update invalid inventory field companyId is received
  Scenario: A request to update invalid inventory field type is received

  Scenario: A request to update an inventory item that does not exists
  Scenario: A request to update an inventory field name to a name that already exists for company
  Scenario: A request to update an inventory with duplicate props
  Scenario: A request to update an inventory props with missing required props
    
  Scenario: A request to update inventory by id is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to update an inventory is received
    Then the response should have a status of 403

  Scenario: A request to update inventory by id is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to update an inventory is received
    Then the response should have a status of 403