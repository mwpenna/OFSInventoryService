@service
Feature: Inventory is created when inventory endpoint is called

  Scenario: A request to create an inventory item is received by a SYSTEM_ADMIN
    Given A SYSTEM_ADMIN user exists and template exists for a company
    When A request to create an inventory item is received
    Then the response should have a status of 201
    And I should see the location header populated

  Scenario: A request to create an inventory item is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received
    Then the response should have a status of 201
    And I should see the location header populated

  Scenario: A request to create an inventory item is received by a ACCOUNT_MANAGER
    Given A ACCOUNT_MANAGER user exists and template exists for a company
    When A request to create an inventory item is received
    Then the response should have a status of 201
    And I should see the location header populated

  Scenario: A request to create an inventory item is received by a CUSTOMER
    Given A CUSTOMER user exists and template exists for a company
    When A request to create an inventory item is received
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received by a WAREHOUSE
    Given A WAREHOUSE user exists and template exists for a company
    When A request to create an inventory item is received
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received
    Then the response should have a status of 201
    And I should see the inventory item was created

  Scenario: A request to create an inventory item is received by a user that does not exists
    Given A ADMIN user does not exists for a company
    When A request to create an inventory item is received for a user that does not exists
    Then the response should have a status of 403

  Scenario: A request to create an inventory item is received with missing field quantity
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received without quantity
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with missing field type
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received without type
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with missing field name
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received without name
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with missing prop field name
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with missing prop name
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with missing prop field type
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with missing prop value
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with invalid field href
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with invalid field href
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with invalid field createdOn
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with invalid field createdOn
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with invalid field id
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with invalid field id
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with invalid prop field required
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with invalid prop required
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with invalid prop field type
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with invalid prop type
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with an inventory type that does not match a company's template
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with an invalid inventory type
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with missing prop values
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with missing prop value
    Then the response should have a status of 400

  Scenario: A request to create an inventory item is received with missing required prop list
    Given A ADMIN user exists and template exists for a company
    When A request to create an inventory item is received with missing props
    Then the response should have a status of 400



