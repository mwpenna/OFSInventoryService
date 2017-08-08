@service
Feature: Inventory list is returned when search by endpoint is called
  Scenario: a request to search for inventory is received by user with ACCOUNT_MANAGER role
    Given A ACCOUNT_MANAGER user exists and inventory exists for a company
    When A request to search for inventory is received
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: a request to search for inventory is received by user with ADMIN role
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: Bad Request is returned when a request to search for inventory is received by user with WAREHOUSE role
    Given A WAREHOUSE user exists and inventory exists for a company
    When A request to search for inventory is received
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search for inventory is received by user with CUSTOMER role
    Given A CUSTOMER user exists and inventory exists for a company
    When A request to search for inventory is received
    Then the response should have a status of 400

  Scenario: Bad Request is returned when a request to search for inventory is received with a search parameter of id
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid search parameter id
    Then the response should have a status of 400
    And I should see an inventory error message with id not allowed

  Scenario: Bad Request is returned when a request to search for inventory is received with a search parameter of href
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid search parameter href
    Then the response should have a status of 400
    And I should see an inventory error message with href not allowed

  Scenario: Bad Request is returned when a request to search for inventory is received with a search parameter of createdOn
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid search parameter createdOn
    Then the response should have a status of 400
    And I should see an inventory error message with createdOn not allowed

  Scenario: Bad Request is returned when a request to search for inventory is received with a search parameter of companyId
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid search parameter companyId
    Then the response should have a status of 400
    And I should see an inventory error message with companyId not allowed

  Scenario: Bad Request is returned when a request to search for inventory is received with a prop search parameter of type
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid prop search parameter type
    Then the response should have a status of 400
    And I should see an inventory error message with props.items.type not allowed

  Scenario: Bad Request is returned when a request to search for inventory is received with a prop search parameter of required
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid prop search parameter required
    Then the response should have a status of 400
    And I should see an inventory error message with props.items.required not allowed

  Scenario: Bad Request is returned when a request to search for inventory is received with a prop search parameter of value
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid prop search parameter value
    Then the response should have a status of 400
    And I should see an inventory error message with props.items.value not allowed

  Scenario: Bad Request is returned when a request to search for inventory is received with a prop search parameter of defaultValue
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with invalid prop search parameter defaultValue
    Then the response should have a status of 400
    And I should see an inventory error message with props.items.defaultValue not allowed

  Scenario: A request to search for inventory is received by ADMIN user with search parameter of type
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with search parameter type
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: A request to search for inventory is received by ADMIN user with search parameter of price
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with search parameter price
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: A request to search for inventory is received by ADMIN user with search parameter of quantity
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with search parameter quantity
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: A request to search for inventory is received by ADMIN user with search parameter of name
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with search parameter name
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: A request to search for inventory is received by ADMIN user with search parameter of description
    Given A ADMIN user exists and inventory exists for a company
    When A request to search for inventory is received with search parameter description
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: A request to search for inventory is received by ADMIN user with a prop search parameter of name
    Given A ADMIN user exists and inventory exists for a company with different prop names
    When A request to search for inventory is received with prop search parameter name
    Then the response should have a status of 200
    And I should see the inventory list was returned

  Scenario: A request to search for inventory is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to search an inventory is received
    Then the response should have a status of 403

  Scenario: A request to get search for inventory is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to search an inventory is received
    Then the response should have a status of 403