@service
Feature: Template is created when template endpoint is called

  Scenario: A request to create a template is received by a SYSTEM_ADMIN
    Given A SYSTEM_ADMIN user exists for a company
    When A request to create a template is received
    Then the response should have a status of 201
    And I should see the location header populated

  Scenario: A request to create a template is received by a ADMIN
    Given A ADMIN user exists for a company
    When A request to create a template is received
    Then the response should have a status of 201
    And I should see the location header populated

  Scenario: A request to create a template is received by a ADMIN
    Given A ADMIN user exists for a company
    When A request to create a template is received
    Then the response should have a status of 201
    And I should the template was created

  Scenario: A request to create a template is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to create a template is received
    Then the response should have a status of 403

  Scenario: A request to create a template is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to create a template is received
    Then the response should have a status of 403

  Scenario: A request to create a template is received by a SYSTEM_ADMIN
    Given A ACCOUNT_MANAGER user exists for a company
    When A request to create a template is received
    Then the response should have a status of 400

  Scenario: A request to create a template is received by a SYSTEM_ADMIN
    Given A WAREHOUSE user exists for a company
    When A request to create a template is received
    Then the response should have a status of 400

  Scenario: A request to create a template is received by a SYSTEM_ADMIN
    Given A CUSTOMER user exists for a company
    When A request to create a template is received
    Then the response should have a status of 400

  Scenario: A request to creaate a template is recived with missing required field name
    Given A ADMIN user exists for a company
    When A request to create a template is received with missing name
    Then the response should have a status of 400
    And I should see an error message with name missing

  Scenario: A request to creaate a template is recived with missing required field props
    Given A ADMIN user exists for a company
    When A request to create a template is received with missing props
    Then the response should have a status of 400
    And I should see an error message with props missing

  Scenario: A request to creaate a template is received with missing required field prop.name
    Given A ADMIN user exists for a company
    When A request to create a template with missing prop field name is received
    Then the response should have a status of 400
    And I should see an error message indicating prop name missing

  Scenario: A request to creaate a template is recived with missing required field prop.type
    Given A ADMIN user exists for a company
    When A request to create a template with missing prop field type is received
    Then the response should have a status of 400
    And I should see an error message indicating prop type missing

  Scenario: A request to creaate a template is recived with missing required field prop.required
    Given A ADMIN user exists for a company
    When A request to create a template with missing prop field required is received
    Then the response should have a status of 400
    And I should see an error message indicating prop required missing

  Scenario: A request to create a template is received with href field
    Given A ADMIN user exists for a company
    When A request to create a template is received with field not allowed href
    Then the response should have a status of 400
    And I should see an error message with href not allowed

  Scenario: A request to create a template is received with createdOn field
    Given A ADMIN user exists for a company
    When A request to create a template is received with field not allowed createdOn
    Then the response should have a status of 400
    And I should see an error message with createdOn not allowed

  Scenario: A request to create a template is received with id field
    Given A ADMIN user exists for a company
    When A request to create a template is received with field not allowed id
    Then the response should have a status of 400
    And I should see an error message with id not allowed

  Scenario: A request to create a template is received with duplicate template name
    Given A ADMIN user and template exists for a company
    When A request to create a duplicate template name is received
    Then the response should have a status of 400

  Scenario: A request to create a template is received by an ADMIN with companyId in the request
    Given A ADMIN user exists for a company
    When A request to create a template is received with a companyId
    Then the response should have a status of 201
    And I should see the companyId is equal to the user companyId

  Scenario: A request to create a template is received by a SYSTEM_ADMIN with companyId in the request
    Given A SYSTEM_ADMIN user exists for a company
    When A request to create a template is received with a companyId
    Then the response should have a status of 201
    And I should see the companyId is equal to the requested companyId

  Scenario: A request to create template with duplicate prop name
    Given A ADMIN user exists and template exists for a company
    When A request to create template with duplicate prop name is received
    Then the response should have a status of 400
    And I should see an error message indicating duplicate props